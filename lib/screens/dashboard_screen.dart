import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/project.dart';
import '../theme/app_colors.dart';
import '../utils/text_format.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/input_dialog.dart';
import '../widgets/project_card.dart';
import 'settings_screen.dart';

/// Halaman utama: daftar project (expandable) + tombol tambah project.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _db = DatabaseHelper.instance;
  List<Project> _projects = [];
  Map<int, int> _counts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Muat ulang daftar project + jumlah task aktif (badge).
  Future<void> _load() async {
    final projects = await _db.getProjects();
    final counts = await _db.activeTaskCounts();
    if (!mounted) return;
    setState(() {
      _projects = projects;
      _counts = counts;
      _loading = false;
    });
  }

  Future<void> _addProject() async {
    final name = await showTextInputDialog(
      context,
      title: 'Tambah Project',
      hint: 'Nama project',
    );
    if (name == null || name.trim().isEmpty) return;
    await _db.insertProject(
      Project(name: toTitleCase(name.trim()), createdAt: DateTime.now()),
    );
    await _load();
  }

  /// Buka form global "Tambah List Tugas" (pilih project + teks).
  Future<void> _addTaskGlobal() async {
    final added = await showAddTaskSheet(context, _projects);
    if (added) await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              // Kalau di Settings ada perubahan data (mis. hapus semua), reload.
              if (changed == true) _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : Column(
              children: [
                Expanded(
                  child: _projects.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          itemCount: _projects.length,
                          itemBuilder: (context, i) {
                            final p = _projects[i];
                            return ProjectCard(
                              key: ValueKey(p.id),
                              project: p,
                              activeCount: _counts[p.id] ?? 0,
                              onChanged: _load,
                            );
                          },
                        ),
                ),
                _buildAddProjectButton(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada project.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Tambah Project" di bawah untuk mulai.',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProjectButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          children: [
            // Primary: tambah tugas cepat (filled teal).
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addTaskGlobal,
                icon: const Icon(Icons.playlist_add),
                label: const Text('Tambah List Tugas'),
              ),
            ),
            const SizedBox(height: 8),
            // Secondary: tambah project (outline).
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addProject,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Project'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

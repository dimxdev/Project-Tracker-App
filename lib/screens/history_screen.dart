import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../widgets/input_dialog.dart';

/// Halaman Riwayat: semua task yang sudah selesai, dikelompokkan per project.
/// Bersifat read-only (arsip / kenang-kenangan).
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _db = DatabaseHelper.instance;

  bool _loading = true;
  // Daftar grup: tiap grup = nama project + task selesai di dalamnya.
  List<_ProjectGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final doneTasks = await _db.getDoneTasks();
    final projects = await _db.getProjects();
    final nameById = {for (final p in projects) p.id!: p.name};

    // Kelompokkan task selesai per project_id (urutan project mengikuti
    // kemunculan pertama task selesai → yg paling baru selesai di atas).
    final Map<int, List<Task>> map = {};
    for (final t in doneTasks) {
      map.putIfAbsent(t.projectId, () => []).add(t);
    }

    final groups = map.entries
        .map((e) => _ProjectGroup(
              projectId: e.key,
              projectName: nameById[e.key] ?? '(project terhapus)',
              tasks: e.value,
            ))
        .toList();

    if (!mounted) return;
    setState(() {
      _groups = groups;
      _loading = false;
    });
  }

  /// Hapus satu task riwayat.
  Future<void> _deleteTask(Task task) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus dari riwayat?',
      message: 'Tugas ini akan dihapus permanen dari arsip.',
    );
    if (!ok) return;
    await _db.deleteTask(task.id!);
    await _load();
  }

  /// Hapus semua task selesai di satu project (per kategori).
  Future<void> _deleteGroup(_ProjectGroup group) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus riwayat "${group.projectName}"?',
      message:
          '${group.tasks.length} tugas selesai di project ini akan dihapus '
          'permanen dari arsip. Tugas aktif tidak terpengaruh.',
    );
    if (!ok) return;
    await _db.deleteDoneTasksByProject(group.projectId);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : _groups.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: _groups.map(_buildGroup).toList(),
                ),
    );
  }

  Widget _buildGroup(_ProjectGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header nama project + tombol hapus seluruh grup.
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Row(
            children: [
              // Nama + jumlah dibungkus Expanded → dorong ikon ke kanan.
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        group.projectName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${group.tasks.length} selesai',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Disamakan setting-nya dengan ikon hapus per-task biar lurus.
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                color: AppColors.textTertiary,
                tooltip: 'Hapus semua riwayat project ini',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                onPressed: () => _deleteGroup(group),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: group.tasks.map(_buildDoneTask).toList(),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDoneTask(Task task) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 10),
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.accent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.content,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                if (task.completedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Selesai: ${task.completedAt!.toString().substring(0, 16)}',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Hapus task ini dari riwayat.
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: AppColors.textTertiary,
            tooltip: 'Hapus dari riwayat',
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            onPressed: () => _deleteTask(task),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.history,
            size: 56,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada tugas selesai.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Tugas yang kamu tandai selesai akan diarsipkan di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Grup task selesai untuk satu project.
class _ProjectGroup {
  final int projectId;
  final String projectName;
  final List<Task> tasks;
  _ProjectGroup({
    required this.projectId,
    required this.projectName,
    required this.tasks,
  });
}

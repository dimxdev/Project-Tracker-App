import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../utils/text_format.dart';
import 'input_dialog.dart';
import 'task_item.dart';

/// Card project yang bisa di-expand.
/// Header: nama project + badge jumlah task aktif.
/// Saat expand: daftar task aktif + tombol "Tambah tugas".
///
/// [onChanged] dipanggil setiap ada perubahan yang memengaruhi badge
/// (tambah/selesai/hapus task) supaya Dashboard refresh angka badge-nya.
class ProjectCard extends StatefulWidget {
  final Project project;
  final int activeCount;
  final VoidCallback onChanged;

  const ProjectCard({
    super.key,
    required this.project,
    required this.activeCount,
    required this.onChanged,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final _db = DatabaseHelper.instance;
  List<Task> _tasks = [];
  bool _loaded = false;

  @override
  void didUpdateWidget(ProjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kalau badge (jumlah task aktif) berubah dari luar — misalnya gara-gara
    // form "Tambah List Tugas" global menambah task ke project ini — dan card
    // sedang/ sudah pernah dibuka, reload daftar task biar ikut update.
    if (_loaded && widget.activeCount != oldWidget.activeCount) {
      _loadTasks();
    }
  }

  /// Muat ulang daftar task aktif project ini dari DB.
  Future<void> _loadTasks() async {
    final tasks = await _db.getActiveTasks(widget.project.id!);
    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _loaded = true;
    });
  }

  /// Refresh task lokal + kabari Dashboard biar badge ikut update.
  Future<void> _refreshAll() async {
    await _loadTasks();
    widget.onChanged();
  }

  Future<void> _addTask() async {
    final content = await showTextInputDialog(
      context,
      title: 'Tambah tugas',
      hint: 'Tulis ide fitur / bug...',
    );
    if (content == null || content.trim().isEmpty) return;
    await _db.insertTask(Task(
      projectId: widget.project.id!,
      content: toTitleCase(content.trim()),
      createdAt: DateTime.now(),
    ));
    await _refreshAll();
  }

  Future<void> _editTask(Task task) async {
    final content = await showTextInputDialog(
      context,
      title: 'Edit tugas',
      initialValue: task.content,
    );
    if (content == null || content.trim().isEmpty) return;
    await _db.updateTask(task.copyWith(content: toTitleCase(content.trim())));
    await _refreshAll();
  }

  Future<void> _markDone(Task task) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Tandai selesai?',
      message: 'Tugas ini akan dipindah ke Riwayat.',
      confirmLabel: 'Selesai',
      confirmColor: AppColors.accent,
      confirmTextColor: AppColors.onAccent,
    );
    if (!ok) return;
    await _db.markTaskDone(task.id!);
    await _refreshAll();
  }

  Future<void> _deleteTask(Task task) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus tugas?',
      message: 'Tugas ini akan dihapus permanen.',
    );
    if (!ok) return;
    await _db.deleteTask(task.id!);
    await _refreshAll();
  }

  /// Edit nama project (lewat menu ⋮).
  Future<void> _editProject() async {
    final name = await showTextInputDialog(
      context, 
      title: 'Ubah nama project',
      initialValue: widget.project.name,
    );
    if (name == null || name.trim().isEmpty) return;
    await _db.updateProject(
        widget.project.copyWith(name: toTitleCase(name.trim())));
    widget.onChanged(); // Dashboard reload → nama ke-update.
  }

  /// Hapus project (lewat menu ⋮). Mengingatkan bahwa semua task ikut terhapus.
  Future<void> _deleteProject() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus project?',
      message:
          'Project "${widget.project.name}" beserta SEMUA tugas di dalamnya '
          '(aktif & selesai) akan dihapus permanen.',
    );
    if (!ok) return;
    await _db.deleteProject(widget.project.id!);
    widget.onChanged(); // Dashboard reload → card hilang.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Theme(
        // Hilangkan garis pembatas default ExpansionTile.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textSecondary,
          onExpansionChanged: (val) {
            if (val && !_loaded) _loadTasks();
          },
          title: Row(
            children: [
              Expanded(
                child: Text(
                  widget.project.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _Badge(count: widget.activeCount),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                color: AppColors.surface,
                tooltip: 'Opsi project',
                onSelected: (value) {
                  if (value == 'edit') _editProject();
                  if (value == 'delete') _deleteProject();
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 10),
                        Text('Ubah nama',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Hapus project',
                            style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            if (!_loaded)
              const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.accent,
                  ),
                ),
              )
            else ...[
              if (_tasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Belum ada tugas aktif.',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                )
              else
                ..._tasks.map((t) => TaskItem(
                      task: t,
                      onDone: () => _markDone(t),
                      onEdit: () => _editTask(t),
                      onDelete: () => _deleteTask(t),
                    )),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah tugas'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Badge bulat angka jumlah task aktif.
class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 28),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: count > 0 ? AppColors.accent : AppColors.border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: count > 0 ? AppColors.onAccent : AppColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

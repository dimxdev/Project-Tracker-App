import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';

/// Satu baris task di dalam project card.
/// Teks di kiri, 3 ikon aksi di kanan: tandai selesai, edit, hapus.
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;  

  const TaskItem({
    super.key,
    required this.task,
    required this.onDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.content,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          // Tandai selesai — pakai aksen teal biar menonjol.
          _ActionIcon(
            icon: Icons.check_circle_outline,
            color: AppColors.accent,
            tooltip: 'Tandai selesai',
            onTap: onDone,
          ),
          // Edit teks.
          _ActionIcon(
            icon: Icons.edit_outlined,
            color: AppColors.textTertiary,
            tooltip: 'Edit',
            onTap: onEdit,
          ),
          // Hapus.
          _ActionIcon(
            icon: Icons.delete_outline,
            color: AppColors.textTertiary,
            tooltip: 'Hapus',
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20, color: color),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(6),
      onPressed: onTap,
    );
  }
}

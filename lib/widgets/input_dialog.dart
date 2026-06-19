import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Dialog input teks reusable.
/// Dipakai buat: tambah project, tambah task, edit task.
/// Return: teks yang diketik (null kalau dibatalkan).
Future<String?> showTextInputDialog(
  BuildContext context, {
  required String title,
  String? initialValue,
  String hint = '',
  String confirmLabel = 'Simpan',
}) {
  final controller = TextEditingController(text: initialValue ?? '');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
      ),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: null,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(color: AppColors.textPrimary),
        cursorColor: AppColors.accent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textTertiary),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.accent),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

/// Dialog konfirmasi (ya/tidak). Return true kalau user pilih konfirmasi.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Hapus',
  Color confirmColor = Colors.redAccent,
  Color confirmTextColor = Colors.white,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 18),
      ),
      content: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: confirmTextColor,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

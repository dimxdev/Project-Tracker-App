import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../utils/text_format.dart';

/// Bottom sheet "Tambah List Tugas" global.
/// Pilih project lewat dropdown + tulis teks tugas, tanpa harus
/// expand project dulu di Dashboard.
///
/// Return `true` kalau ada task baru yang berhasil disimpan
/// (biar Dashboard bisa refresh).
Future<bool> showAddTaskSheet(
  BuildContext context,
  List<Project> projects,
) async {
  // Gak ada project sama sekali → kasih tau user bikin project dulu.
  if (projects.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buat project dulu sebelum menambah tugas.'),
      ),
    );
    return false;
  }

  final controller = TextEditingController();
  Project selected = projects.first;
  bool saved = false;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true, // biar naik saat keyboard muncul
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        // Dorong konten ke atas keyboard.
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah List Tugas',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown pilih project.
                  const Text(
                    'Project',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Project>(
                        value: selected,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        iconEnabledColor: AppColors.textSecondary,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: projects
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p.name),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setSheet(() => selected = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input teks tugas.
                  const Text(
                    'Tugas',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(color: AppColors.textPrimary),
                    cursorColor: AppColors.accent,
                    decoration: InputDecoration(
                      hintText: 'Tulis ide fitur / bug...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.background,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol simpan.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        await DatabaseHelper.instance.insertTask(Task(
                          projectId: selected.id!,
                          content: toTitleCase(text),
                          createdAt: DateTime.now(),
                        ));
                        saved = true;
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );

  return saved;
}

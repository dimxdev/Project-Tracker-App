import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/project.dart';
import '../models/task.dart';

/// Satu-satunya pintu masuk ke database SQLite.
/// Pakai pola singleton: cukup satu instance buat seluruh app.
/// Akses lewat `DatabaseHelper.instance`.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'project_tracker.db';
  static const _dbVersion = 1;

  Database? _db;

  /// Ambil koneksi DB (buka kalau belum kebuka).
  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      // Aktifkan foreign key biar relasi project-task ditegakkan DB.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Dipanggil sekali saat DB pertama kali dibuat.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        completed_at TEXT,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');
  }

  // ===================== PROJECT =====================

  Future<int> insertProject(Project project) async {
    final db = await database;
    return db.insert('projects', project.toMap()..remove('id'));
  }

  Future<List<Project>> getProjects() async {
    final db = await database;
    final rows = await db.query('projects', orderBy: 'created_at DESC');
    return rows.map((r) => Project.fromMap(r)).toList();
  }

  Future<int> updateProject(Project project) async {
    final db = await database;
    return db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  /// Hapus project. Karena ON DELETE CASCADE, semua task-nya ikut terhapus.
  Future<int> deleteProject(int id) async {
    final db = await database;
    return db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }

  /// Hitung jumlah task aktif (belum selesai) per project → buat badge.
  /// Mengembalikan Map: {projectId: jumlah}.
  Future<Map<int, int>> activeTaskCounts() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT project_id, COUNT(*) AS cnt
      FROM tasks
      WHERE is_done = 0
      GROUP BY project_id
    ''');
    return {
      for (final r in rows) r['project_id'] as int: r['cnt'] as int,
    };
  }

  // ===================== TASK =====================

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap()..remove('id'));
  }

  /// Ambil task AKTIF (belum selesai) untuk satu project, terbaru di atas.
  Future<List<Task>> getActiveTasks(int projectId) async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'project_id = ? AND is_done = 0',
      whereArgs: [projectId],
      orderBy: 'created_at DESC',
    );
    return rows.map((r) => Task.fromMap(r)).toList();
  }

  /// Ambil semua task SELESAI (buat halaman Riwayat).
  Future<List<Task>> getDoneTasks() async {
    final db = await database;
    final rows = await db.query(
      'tasks',
      where: 'is_done = 1',
      orderBy: 'completed_at DESC',
    );
    return rows.map((r) => Task.fromMap(r)).toList();
  }

  /// Update isi/teks task (buat fitur edit).
  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Tandai task selesai → set is_done = 1 + catat waktu selesai.
  Future<int> markTaskDone(int taskId) async {
    final db = await database;
    return db.update(
      'tasks',
      {
        'is_done': 1,
        'completed_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  /// Hapus semua task SELESAI di satu project (buat "hapus per kategori"
  /// di halaman Riwayat). Task aktif tidak ikut terhapus.
  Future<int> deleteDoneTasksByProject(int projectId) async {
    final db = await database;
    return db.delete(
      'tasks',
      where: 'project_id = ? AND is_done = 1',
      whereArgs: [projectId],
    );
  }

  // ===================== UTIL =====================

  /// Hapus SELURUH data (semua project + semua task). Buat menu Settings.
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('tasks');
    await db.delete('projects');
  }
}

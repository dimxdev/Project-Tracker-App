/// Model untuk satu Task (catatan ide/bug).
/// Merepresentasikan satu baris di tabel `tasks`.
class Task {
  final int? id; // null saat belum disimpan ke DB.
  final int projectId; // FK ke projects.id
  final String content;
  final bool isDone;
  final DateTime createdAt;
  final DateTime? completedAt; // null kalau belum selesai.

  const Task({
    this.id,
    required this.projectId,
    required this.content,
    this.isDone = false,
    required this.createdAt,
    this.completedAt,
  });

  /// Ubah object jadi Map buat disimpan ke SQLite.
  /// SQLite gak punya tipe boolean, jadi is_done disimpan sebagai 0/1.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'content': content,
      'is_done': isDone ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Bikin object Task dari Map hasil query SQLite.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      projectId: map['project_id'] as int,
      content: map['content'] as String,
      isDone: (map['is_done'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  /// Salin object dengan sebagian field diubah (berguna buat edit/tandai selesai).
  Task copyWith({
    int? id,
    int? projectId,
    String? content,
    bool? isDone,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

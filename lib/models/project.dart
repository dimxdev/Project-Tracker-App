/// Model untuk satu Project (kategori).
/// Merepresentasikan satu baris di tabel `projects`.
class Project {
  final int? id; // null saat belum disimpan ke DB (id di-generate auto).
  final String name;
  final DateTime createdAt;

  const Project({
    this.id,
    required this.name,
    required this.createdAt,
  });

  /// Ubah object jadi Map buat disimpan ke SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Bikin object Project dari Map hasil query SQLite.
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Salin object dengan sebagian field diubah (berguna buat edit).
  Project copyWith({int? id, String? name, DateTime? createdAt}) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

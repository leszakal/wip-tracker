class Stage {
  final int? id;
  final int pid;
  final String? name;
  final DateTime timestamp;
  final String? description;
  final String? notes;
  final String? image;

  Stage({
    required this.timestamp,
    required this.pid,
    this.id,
    this.name,
    this.description,
    this.notes,
    this.image,
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'project_id': pid,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'image': image,
      'description': description,
      'notes': notes,
    };
  }

}
import '../../stage/data/stage.dart';

class Project {
  final int id;
  final String title;
  final String? description;
  final String? notes;
  final List<String>? tags;
  final List<Stage>? stages;
  final DateTime start;
  final DateTime? end;
  final bool complete;

  Project({
    required this.id,
    required this.title,
    required this.start,
    this.description,
    this.notes,
    this.tags,
    this.stages, 
    this.end,
    this.complete = false,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'start': start.millisecondsSinceEpoch,
      'description': description,
      'notes': notes,
      'end': end?.millisecondsSinceEpoch,
      'complete': complete,
    };
  }
}
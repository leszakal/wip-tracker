import '../../stage/data/stage.dart';

class Project {
  final int? id;
  final String title;
  final String? image;
  final String? description;
  final String? notes;
  final List<String>? tags;
  final List<Stage>? stages;
  final DateTime start;
  final DateTime lastModified;
  final DateTime? end;
  final bool complete;

  Project({
    required this.title,
    required this.start,
    required this.lastModified,
    this.id,
    this.image,
    this.description,
    this.notes,
    this.tags,
    this.stages, 
    this.end,
    this.complete = false,
  });

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'start': start.millisecondsSinceEpoch,
      'lastModified': lastModified.millisecondsSinceEpoch,
      'image': image,
      'description': description,
      'notes': notes,
      'end': end?.millisecondsSinceEpoch,
      'complete': complete == true ? 1 : 0,
    };
  }
}
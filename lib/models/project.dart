import 'stage.dart';

class Project {
  final String id;
  final String? title;
  final String? description;
  final String? notes;
  final List<String>? tags;
  final List<Stage>? stages;
  final DateTime start;
  final DateTime? end;
  final bool complete;

  Project(
    this.id,
    this.title,
    this.description,
    this.notes,
    this.tags,
    this.stages, 
    this.start,
    this.end,
    this.complete,
  );
}
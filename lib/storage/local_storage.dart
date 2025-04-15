import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../project/data/project.dart';

class LocalStorage {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(
      join(await getDatabasesPath(), path), version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
CREATE TABLE projects (
  id INT PRIMARY KEY AUTOINCREMENT, 
  title TEXT NOT NULL,
  image TEXT, 
  description TEXT, 
  notes TEXT,
  start INT NOT NULL,
  end INT,
  complete BOOL,
  ))
''');
      }
    );
  }

  Future<void> insertProject(Project project) async {
    await db.insert(
      'projects',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // https://docs.flutter.dev/cookbook/persistence/sqlite
  Future<List<Project>?> getProjects() async {
    final List<Map<String, Object?>> projectMaps = await db.query('projects');
    return [
      for (final {'id': id as int, 'title': title as String, 'image': image as String, 
        'description': description as String, 'notes': notes as String,
        'start': start as int, 'end': end as int, 'complete': complete as bool
        } in projectMaps)
      Project(
        id: id, title: title, image: image, description: description, notes: notes,
        start: DateTime.fromMicrosecondsSinceEpoch(start), end: DateTime.fromMicrosecondsSinceEpoch(end), 
        complete: complete,
      ),
    ];
  }
}
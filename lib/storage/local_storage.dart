import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../project/data/project.dart';
import '../stage/data/stage.dart';

class LocalStorage {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(
      join(await getDatabasesPath(), path), version: 1,
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE projects (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT NOT NULL,
            image TEXT, 
            description TEXT, 
            notes TEXT,
            start INTEGER NOT NULL,
            end INTEGER,
            complete INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE stages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            project_id INTEGER NOT NULL,
            name TEXT,
            timestamp INTEGER NOT NULL,
            description TEXT,
            notes TEXT,
            image TEXT,
            FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE tags (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            count INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE project_tags (
            project_id INTEGER,
            tag_id INTEGER,
            FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
            FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE
          )
        ''');
      }
    );
  }

  Future<int> insertProject(Project project) async {
    return await db.insert(
      'projects',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // https://docs.flutter.dev/cookbook/persistence/sqlite
  Future<List<Project>> getProjects() async {
    final List<Map<String, Object?>> projectMaps = await db.query('projects', orderBy: 'start DESC');
    if (projectMaps.isEmpty) {
      return [];
    }

    return [
      for (final {'id': id as int, 'title': title as String, 'image': image as String?, 
        'description': description as String?, 'notes': notes as String?,
        'start': start as int, 'end': end as int?, 'complete': complete as int,
        } in projectMaps)
      Project(
        id: id, title: title, image: image, description: description, notes: notes,
        start: DateTime.fromMillisecondsSinceEpoch(start), end: end == null ? null : DateTime.fromMillisecondsSinceEpoch(end), 
        complete: complete == 1 ? true : false, tags: await getProjectTags(id),
      ),
    ];
  }

  Future<Project?> getProjectById(int pid) async {
    final List<Map<String, Object?>> projectMaps = await db.query(
      'projects',
      where: 'id = ?',
      whereArgs: [pid],
    );
    
    if (projectMaps.isEmpty) {
      return null;
    }
    
    final {'id': id as int, 'title': title as String, 'image': image as String?, 
      'description': description as String?, 'notes': notes as String?,
      'start': start as int, 'end': end as int?, 'complete': complete as int,
    } = projectMaps[0];

    return Project(
      id: id, title: title, image: image, description: description, notes: notes,
      start: DateTime.fromMillisecondsSinceEpoch(start), end: end == null ? null : DateTime.fromMillisecondsSinceEpoch(end), 
      complete: complete == 1 ? true : false, tags: await getProjectTags(id),
    );
  }

  Future<void> updateProject(Project project, List<String> tags) async {
    await db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
    
    // Delete current project_tags
    await db.delete(
      'project_tags',
      where: 'project_id = ?',
      whereArgs: [project.id],
    );

    // Add updated tags (if there are any)
    if (tags.isNotEmpty) {
      await insertTags(project.id!, tags);
    }
  }

  Future<void> deleteProject(int id) async {
    await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertStage(Stage stage) async {
    return await db.insert(
      'stages',
      stage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateStage(Stage stage) async {
    if (stage.id == null) return;
    await db.update(
      'stages',
      stage.toMap(),
      where: 'id = ?',
      whereArgs: [stage.id],
    );
  }

  Future<void> deleteStage(int id) async {
    await db.delete(
      'stages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Stage>> getStagesForProject(int projectId) async {
    final List<Map<String, Object?>> stageMaps = await db.query(
      'stages',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'timestamp DESC',
    );

    if (stageMaps.isEmpty) {
      return [];
    }

    return [
      for (final {'id': id as int, 'project_id': pid as int, 'name': name as String?,
        'timestamp': timestamp as int, 'description': description as String?,
        'notes': notes as String?, 'image': image as String?,
      } in stageMaps)
      Stage(
        id: id, pid: pid, name: name, 
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        description: description, notes: notes, image: image,
      ),
    ];
  }

  Future<int?> getInitialStage(int projectId) async {
    final List<Map<String, Object?>> stageMaps = await db.query(
      'stages',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'id ASC',
      limit: 1,
    );

    if (stageMaps.isEmpty) {
      return null;
    }
    return stageMaps[0]['id'] as int;
  }

  Future<void> insertTags(int pid, List<String> tags) async {
    final batch = db.batch();

    for (String tag in tags) {
      // Check if there are any tags with the same name already
      List<Map> results = await db.query(
        'tags',
        where: 'name = ?',
        whereArgs: [tag],
      );

      int tid, curCount;
      if (results.isEmpty) {
        tid = await db.insert(
          'tags', 
          {'name': tag, 'count': 1}
        );
      }
      else {
        tid = results.first['id'];
        curCount = results.first['count'];
        // increment tag count
        await db.update(
          'tags', 
          {'count': curCount + 1},
          where: 'id = ?',
          whereArgs: [tid],
        );
      }

      await db.insert(
        'project_tags', 
        {'project_id': pid, 'tag_id': tid}
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<String>> getProjectTags(int pid) async {
    final List<Map<String, Object?>> tagMaps = await db.rawQuery('''
      SELECT tags.name FROM tags
      JOIN project_tags ON tags.id = project_tags.tag_id
      WHERE project_tags.project_id = ?
    ''', [pid]);

    return [
      for (final {'name': name as String} in tagMaps) name
    ];
  }

}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> saveImageLocally(File imageFile, String imagePath) async {
  final path = await _localPath;
  String imageName = basename(imagePath);
  await imageFile.copy('$path/$imageName');
  return '$path/$imageName';
}
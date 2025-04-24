// file: project_detail.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../data/project.dart';
import '../../storage/local_storage.dart';
import 'project_list.dart';
import 'package:go_router/go_router.dart';

class ProjectDetail extends StatelessWidget {
  final Project project;
  final LocalStorage localStorage;

  const ProjectDetail({super.key, required this.project, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.image != null)
              Image.file(
                File(project.image!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16),
            Text(
              project.description != null ? '${project.description}' : 'No description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            if (project.notes != null)
            Text(
              'Notes:\n${project.notes}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Text("Start: ${project.start.toLocal()}"),
            ElevatedButton(
              onPressed: () async {
                await localStorage.open('wip_tracker.db');
                await localStorage.deleteProject(project.id!);
                if (context.mounted) {
                  context.go('/');
                }
              },
              child: Text('delete')),
          ],
        ),
      ),
    );
  }
}

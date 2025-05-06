// file: project_detail.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../data/project.dart';
import '../../storage/local_storage.dart';
import 'project_edit.dart';
import 'project_list.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProjectDetail extends StatefulWidget {
  final Project project;

  const ProjectDetail({super.key, required this.project});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  late Project project;
  final _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    project = widget.project; // Initialize with the passed project
  }

  void _reloadPage() {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getProjectById(project.id!).then((value) {
        setState(() {
          if (value == null) {
            debugPrint('Project not found');
            return;
          }
          else {
            project = value;
          }
        });
      });
    });
  }

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
            if (project.notes != null && project.notes!.isNotEmpty)
            Text(
              'Notes:\n${project.notes}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 12),
            Text("Start: ${DateFormat.yMd().format(project.start)}"),
            Row(
              children: [
                Text('Tags: '),
                if (project.tags == null || project.tags!.isEmpty)
                  Text('<None>')
                else
                  for (int i = 0; i < project.tags!.length; i++)
                    (i != project.tags!.length - 1) ?
                    Text('${project.tags![i]}, ')
                    : Text(project.tags![i]),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                onPressed: () async {
                    await _localStorage.open('wip_tracker.db');
                    await _localStorage.deleteProject(project.id!);
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  child: Text('delete')
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectEdit(project: project)),
                    );
                    if (result == true) {
                      _reloadPage();
                    }
                  },
                  child: Text('edit')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

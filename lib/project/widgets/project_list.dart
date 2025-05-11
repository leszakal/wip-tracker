import 'dart:io';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'project_card.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';
import '../../storage/local_storage.dart';
import 'project_add.dart';

class ProjectList extends StatefulWidget {
  final bool? reload;
  const ProjectList({super.key, this.reload});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project>? projects;
  final _localStorage = LocalStorage();

  void _loadProjects() {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getProjects().then((value) {
        setState(() {
          projects = value;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reload == true) {
      _loadProjects();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Projects'),
      ),
      drawer: const MyDrawer(currentPage: 1),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: projects == null ?
          CircularProgressIndicator()
          : projects!.isEmpty ? 
          Text(
            "No projects yet -- add one!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ) 
          : ListView.builder(
            itemCount: projects!.length,
            itemBuilder: (context, index) {
              final project = projects![index];
              return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: ProjectCard(project: project),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectAdd()),
          );
          if (result == true) {
            _loadProjects();
          }
        },
        tooltip: "Add a new project",
        child: Icon(Icons.add),
      ),
    );
  }
}
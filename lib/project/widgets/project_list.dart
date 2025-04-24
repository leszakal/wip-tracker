import 'dart:io';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:wip_tracker/project/widgets/project_add.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';
import '../../storage/local_storage.dart';
import 'project_detail.dart';

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
            MaterialPageRoute(builder: (context) => const ProjectAdd()),
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

class ProjectCard extends StatelessWidget {
  final Project project;
  
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 150,
          maxHeight: 300,
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.deepPurple.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProjectDetail(project: project, localStorage: LocalStorage())),
              );
            },
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                          child: Text(project.title),
                        )
                      ),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  if (project.image != null) 
                  Column(
                    children: [
                      Divider(height: 1),
                      FittedBox(
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(
                          width: 350,
                          height: 180,
                          File(project.image!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Divider(height: 1),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text('Stage name'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Row(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
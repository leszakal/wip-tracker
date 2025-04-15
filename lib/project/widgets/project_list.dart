import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wip_tracker/project/widgets/project_add.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key, required this.title});
  final String title;

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project>? projects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(currentPage: 1),
      body: Center(
        child: ListView(
            children: <Widget>[
              if (projects == null || projects!.isEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 28.0, 8.0, 0.0),
                child: Text(
                  "No projects yet -- add a new one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
           ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectAdd()),
          );
        },
        tooltip: "Add a new project",
        child: Icon(Icons.add),
      ),
    );
  }
}
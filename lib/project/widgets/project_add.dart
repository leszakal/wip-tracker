import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:image_picker/image_picker.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';
import 'project_form.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({super.key});
  final String title = 'Add New Project';

  @override
  State<ProjectAdd> createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: BackButton(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AddForm(formType: 'add'),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Redirect to projects page
          Navigator.pop(context);
        },
        tooltip: "Finish editing and add project",
        label: const Text('Done'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
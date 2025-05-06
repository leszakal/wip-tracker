import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:image_picker/image_picker.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';
import 'project_form.dart';

class ProjectEdit extends StatefulWidget {
  const ProjectEdit({super.key, required this.project});
  final String title = 'Edit Project';
  final Project project;

  @override
  State<ProjectEdit> createState() => _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
  final GlobalKey<ProjectFormState> _projectFormKey = GlobalKey<ProjectFormState>();
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
          child: ProjectForm(key: _projectFormKey, formType: 'edit', project: widget.project),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _projectFormKey.currentState?.submitForm().then((value) {
            if (value == true && context.mounted) {
              Navigator.pop(context, true);
            }
            else {
              SnackBar(content: Text('ERROR: Failed to submit edits'));
            }
          });
        },
        tooltip: "Finish editing and save changes",
        label: const Text('Save'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
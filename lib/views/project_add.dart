import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:image_picker/image_picker.dart';

import 'drawer.dart';
import '../models/project.dart';
import '../models/stage.dart';
import '../widgets/add_form.dart';

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
        AddForm(formType: 'project');
      ),
    );
  }
}
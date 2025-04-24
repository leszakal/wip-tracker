import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wip_tracker/project/widgets/default_tags.dart';

import '../../image/image_upload.dart';
import '../../storage/local_storage.dart';
import '../../image/image_placeholder.dart';
import '../data/project.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({super.key, required this.formType});
  final String formType;

  @override
  State<ProjectForm> createState() => ProjectFormState();
}

class ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  final _customTagsController = TextEditingController();
  final _localStorage = LocalStorage();

  XFile? image;
  String? startDate;

  Map<String, bool> defaultTags = {
    'art': false,
    'drawing': false, 
    'painting': false, 
    'pottery': false, 
    'woodwork': false, 
    'ceramics': false, 
    'printmaking': false, 
    'knitting': false,
  };
  
  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    else if (value.length > 60) {
      return 'Title cannot be longer than 60 characters';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a start date';
    }
    return null;
  }

  Future<bool> submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imagePath;
      if (image != null && !kIsWeb) {
        imagePath = await saveImageLocally(File(image!.path), image!.path);
      }
      final project = Project(
        title: _titleController.text,
        start: DateTime.now(),
        image: imagePath,
        description: _descController.text,
        notes: _notesController.text,
      );
      
      // Tag handling
      List<String> customTags = _normalizeCustomTags(_customTagsController.text);
      List<String> tags = gatherTags(customTags, defaultTags);

      // Local db updates
      if (!kIsWeb) {
        await _localStorage.open('wip_tracker.db');
        int pid = await _localStorage.insertProject(project);
        await _localStorage.insertTags(pid, tags);
      }

      return true;
    }
    return false;
  }

  void onImageSelect(XFile selectedImage) {
    setState(() {
      image = selectedImage;
    });
  }

  void toggleTag(String tag) {
    setState(() {
      defaultTags[tag] = !defaultTags[tag]!;
    });
  }

  // void onDateSelect(DateTime selectedDate) {
  //   String selectedDateString = 
  //   setState(() {
  //     startDate = selectedDateString;
  //   });
  // }

  List<String> _normalizeCustomTags(String customTagsText) {
    List<String> tags = customTagsText.split(',');
    List<String> normalizedTags = [];
    for (String tag in tags) {
      if (tag != '') {
        tag = tag.trim();
        tag = tag.toLowerCase();
        normalizedTags.add(tag);
      }
    }
    return normalizedTags;
  }

  List<String> gatherTags(List<String> customTags, Map<String, bool> defaultTags) {
    List<String> projectTags = [];
    if (customTags.isNotEmpty) {
      for (String tag in customTags) {
        projectTags.add(tag);
      }
    }
    if (defaultTags.isNotEmpty) {
      for (String tag in defaultTags.keys) {
        if (defaultTags[tag] == true) {
          projectTags.add(tag);
        }
      }
    }
    projectTags.sort((a, b) => a.toString().compareTo(b.toString()));
    return projectTags;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 18.0, 12.0),
                child: 
                  Column(
                    children: [
                      if (image == null)
                      ImagePlaceholder()
                      else if (image != null)
                      kIsWeb ? Image.network(image!.path, height: 500) :
                      Image.file(File(image!.path), height: 300),
                      ImageUpload(onImageSelect: onImageSelect),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Landscape in Acryllic',
                            helperText: 'Enter a name for this project',
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateTitle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: GestureDetector(
                          onTap: () {
                            
                          },
                          child: TextFormField(
                            controller: _dateController,
                            //initialValue: ,
                            decoration: const InputDecoration(
                              hintText: 'MM/DD/YYYY',
                              helperText: 'Enter a start date for this project (MM/DD/YYYY)',
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateDate,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: InputDatePickerFormField(
                          firstDate: DateTime(2010), 
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                          fieldLabelText: 'Start Date',
                          fieldHintText: 'MM/DD/YYYY',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _descController,
                          decoration: const InputDecoration(
                            helperText: 'Add a description',
                            hintText: 'Optional description...',
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          minLines: 5,
                          maxLines: 5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            helperText: 'Add some notes',
                            hintText: 'Optional notes...',
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          minLines: 5,
                          maxLines: 5,
                        ),
                      ),
                      DefaultTagsCheckboxList(
                        defaultTags: defaultTags,
                        toggleTag: toggleTag,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _customTagsController,
                          decoration: const InputDecoration(
                            helperText: 'Specify custom tags',
                            hintText: 'custom_tag_example, another_tag',
                            labelText: 'Add custom tags',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          minLines: 3,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
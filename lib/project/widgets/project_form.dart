import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image/image_upload.dart';
import '../../storage/local_storage.dart';
import '../../image/image_placeholder.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key, required this.formType});
  final String formType;

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  final _customTagsController = TextEditingController();

  XFile? image;
  
  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    else if (value.length > 60) {
      return 'Title cannot be longer than 60 characters';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      
    }
  }

  void onImageSelect(XFile selectedImage) {
    setState(() {
      image = selectedImage;
    });
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
                        child: InputDatePickerFormField(
                          firstDate: DateTime(2010), 
                          lastDate: DateTime(2030),
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
                      CheckboxListTileExample(),
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

class CheckboxListTileExample extends StatefulWidget {
  const CheckboxListTileExample({super.key});

  @override
  State<CheckboxListTileExample> createState() => _CheckboxListTileExampleState();
}

class _CheckboxListTileExampleState extends State<CheckboxListTileExample> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 4.0),
          child:
            Text(
              'Tags',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          children: [
            for (String tag in defaultTags.keys)
            CheckboxListTile(
              title: Text(tag),
              value: defaultTags[tag], 
              onChanged: (bool? value) {
                setState(() {
                  defaultTags[tag] = value!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wip_tracker/interface/date_picker_form.dart';
import 'package:intl/intl.dart';

import '../../image/image_upload.dart';
import '../../storage/local_storage.dart';
import '../../image/image_placeholder.dart';
import '../data/stage.dart';

class StageForm extends StatefulWidget {
  const StageForm({super.key, required this.formType, required this.pid, this.stage});
  final String formType;
  final Stage? stage;
  final int pid;

  @override
  State<StageForm> createState() => StageFormState();
}

class StageFormState extends State<StageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  final _localStorage = LocalStorage();

  XFile? image;
  DateTime timestamp = DateTime.now();
  bool imageChanged = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat.yMd().format(timestamp).toString();
    if (widget.formType == 'edit') {
      // Populate the form with previously saved data
      debugPrint('Stage ID is: ${widget.stage!.id}');
      _nameController.text = widget.stage!.name ?? '';
      timestamp = widget.stage!.timestamp;
      _dateController.text = DateFormat.yMd().format(widget.stage!.timestamp).toString();
      _descController.text = widget.stage!.description ?? '';
      _notesController.text = widget.stage!.notes ?? '';
      image = widget.stage!.image != null ? XFile(widget.stage!.image!) : null;
    }
  }

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
  
  String? _validateName(String? value) {
    if (value!.length > 60) {
      return 'Name cannot be longer than 60 characters';
    }
    return null;
  }

  Future<bool> submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imagePath;
      if (widget.formType == 'edit') {
        imagePath = widget.stage?.image;
      }
      if (image != null && !kIsWeb && imageChanged == true) {
        imagePath = await saveImageLocally(File(image!.path), image!.path);
      }
      final stage = Stage(
        id: widget.formType == 'edit' ? widget.stage!.id : null,
        pid: widget.pid,
        name: _nameController.text,
        timestamp: timestamp,
        description: _descController.text,
        notes: _notesController.text,
        image: imagePath,
      );

      // Local db updates
      if (!kIsWeb) {
        await _localStorage.open('wip_tracker.db');
        if (widget.formType == 'add') {
          await _localStorage.insertStage(stage);
        }
        else if (widget.formType == 'edit') {
          await _localStorage.updateStage(stage);
        }
      }
      return true;
    }
    return false;
  }

  void onImageSelect(XFile selectedImage) {
    setState(() {
      image = selectedImage;
      imageChanged = true;
    });
  }

  void onDateSelect(DateTime selectedDate) {
    setState(() {
      timestamp = selectedDate;
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
                      kIsWeb ? Image.network(image!.path, height: 500) :
                      Image.file(File(image!.path), height: 300),
                      ImageUpload(onImageSelect: onImageSelect),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Stage 2',
                            helperText: 'Enter a name for this stage',
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateName,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: DatePickerFormField(
                          onDateSelected: onDateSelect,
                          controller: _dateController,
                          initialDate: timestamp,
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
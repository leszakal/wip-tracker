import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter a name for this project',
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          //validator: _validateNum,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: InputDatePickerFormField(
                          firstDate: DateTime(2010), 
                          lastDate: DateTime(2030)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                        child: TextFormField(
                          controller: _descController,
                          decoration: const InputDecoration(
                            hintText: 'Optional description...',
                            labelText: 'Description',
                            border: OutlineInputBorder(),
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
                            hintText: 'Optional notes...',
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
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
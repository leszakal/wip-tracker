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
  
  @override
  Widget build(BuildContext context) {
    String title;
    if (widget.formType == 'project') {
      title = 'Add Project';
    }
    else {
      title = 'Add Stage';
    }
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(title),
      //   leading: BackButton(),
      // ),
      body: Center(
        child: Column(
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
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              labelText: 'Enter a name for this project',
                            ),
                            //validator: _validateNum,
                          ),
                          InputDatePickerFormField(firstDate: DateTime(2010), lastDate: DateTime(2030)),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
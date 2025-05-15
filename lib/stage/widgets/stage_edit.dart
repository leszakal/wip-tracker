import 'package:flutter/material.dart';
import '../data/stage.dart';
import 'stage_form.dart';

class StageEdit extends StatefulWidget {
  const StageEdit({super.key, required this.stage});
  final String title = 'Edit Stage';
  final Stage stage;

  @override
  State<StageEdit> createState() => _StageEditState();
}

class _StageEditState extends State<StageEdit> {
  final GlobalKey<StageFormState> _stageFormKey = GlobalKey<StageFormState>();
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
          child: StageForm(key: _stageFormKey, formType: 'edit', stage: widget.stage, pid: widget.stage.pid),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _stageFormKey.currentState?.submitForm().then((value) {
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
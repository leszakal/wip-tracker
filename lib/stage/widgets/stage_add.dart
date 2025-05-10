import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'stage_form.dart';

class StageAdd extends StatefulWidget {
  const StageAdd({super.key, required this.pid});
  final int pid;
  final String title = 'Add New Stage';

  @override
  State<StageAdd> createState() => _StageAddState();
}

class _StageAddState extends State<StageAdd> {
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
          child: StageForm(
            key: _stageFormKey, 
            formType: 'add',
            pid: widget.pid,
          ),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _stageFormKey.currentState?.submitForm().then((value) {
            if (value == true && context.mounted) {
              Navigator.pop(context, true);
            }
            else {
              SnackBar(content: Text('ERROR: Failed to submit form'));
            }
          });
        },
        tooltip: "Finish editing and add stage",
        label: const Text('Done'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
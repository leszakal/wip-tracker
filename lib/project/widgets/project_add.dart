import 'package:flutter/material.dart';
import 'project_form.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({super.key});
  final String title = 'Add New Project';

  @override
  State<ProjectAdd> createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
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
          child: ProjectForm(key: _projectFormKey, formType: 'add'),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _projectFormKey.currentState?.submitForm().then((value) {
            if (value == true && context.mounted) {
              Navigator.pop(context, true);
            }
            else {
              SnackBar(content: Text('ERROR: Failed to submit form'));
            }
          });
        },
        tooltip: "Finish editing and add project",
        label: const Text('Done'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
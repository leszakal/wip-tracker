import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String objectName;
  final VoidCallback onConfirm;
  const DeleteDialog({super.key, required this.objectName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed:
          () => showDialog<String>(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: Text('Delete $objectName'),
                  content: Text('Are you sure you want to delete $objectName?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Delete');
                        onConfirm();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
          ),
      label: const Text('Delete'),
      icon: const Icon(Icons.delete),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red[800],
        side: BorderSide(color: Colors.red[800]!),
      ),
    );
  }
}
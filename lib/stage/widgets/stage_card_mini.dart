import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/stage.dart';

class StageCardMini extends StatelessWidget {
  final Stage stage;
  
  const StageCardMini({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: stage.name!.isNotEmpty ? Text(stage.name!) : Text('Stage ${stage.id}'),
              subtitle: Text(DateFormat.yMd().format(stage.timestamp).toString()),
              trailing: Image.file(File(stage.image!), width: 60, height: 60, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
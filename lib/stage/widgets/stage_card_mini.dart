import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/stage.dart';

class StageCardMini extends StatelessWidget {
  final Stage stage;
  
  const StageCardMini({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.deepPurple.withAlpha(30),
          onTap: () {
            context.pushNamed('stages', pathParameters: {'pid': stage.pid.toString(), 'sid': stage.id.toString()});
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: stage.name!.isNotEmpty ? Text(stage.name!) : Text('Stage ${stage.id}'),
                subtitle: Text(DateFormat.yMd().format(stage.timestamp).toString()),
                trailing: 
                  stage.image != null 
                  ? Image.file(File(stage.image!), width: 60, height: 60, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/stage.dart';

class StageCard extends StatelessWidget {
  final Stage stage;
  
  const StageCard({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 150,
          maxHeight: 300,
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.deepPurple.withAlpha(30),
            onTap: () {
              context.pushNamed('stages', pathParameters: {'pid': stage.pid.toString(), 'sid': stage.id.toString()});
            },
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: 
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                stage.name!.isNotEmpty 
                                ? Text(stage.name!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)) 
                                : Text('Stage ${stage.id}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                Text(DateFormat.yMd().format(stage.timestamp).toString()),
                              ],
                            ),
                          )
                      ),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  if (stage.image != null) 
                  Column(
                    children: [
                      Divider(height: 1),
                      FittedBox(
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(
                          width: 350,
                          height: 175,
                          File(stage.image!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Divider(height: 1),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    child: Text(
                      stage.description!.isNotEmpty ? stage.description! : 'No description...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
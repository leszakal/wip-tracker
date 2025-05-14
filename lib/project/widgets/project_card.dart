import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../stage/data/stage.dart';
import '../data/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final Stage latestStage;
  
  const ProjectCard({super.key, required this.project, required this.latestStage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 150,
          maxHeight: 310,
        ),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.deepPurple.withAlpha(30),
            onTap: () {
              context.pushNamed('projects', pathParameters: {'pid': project.id.toString()});
            },
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 2.0),
                              child: Text(project.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                              child: Text('Last update: ${DateFormat.yMd().format(latestStage.timestamp).toString()}'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  if (project.image != null) 
                  Container(
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        Divider(height: 1),
                        FittedBox(
                          clipBehavior: Clip.hardEdge,
                          child: Image.file(
                            width: 350,
                            height: 180,
                            File(latestStage.image!),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Divider(height: 1),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text('Latest stage: ${latestStage.name!}'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Text('Tags: '),
                        if (project.tags == null || project.tags!.isEmpty)
                          Text('<None>')
                        else
                          for (int i = 0; i < project.tags!.length; i++)
                            (i != project.tags!.length - 1) ?
                            Text('${project.tags![i]}, ')
                            : Text(project.tags![i]),
                      ],
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
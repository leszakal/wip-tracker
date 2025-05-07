import 'dart:io';

import 'package:flutter/material.dart';
import '../data/project.dart';
import 'project_detail.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  
  const ProjectCard({super.key, required this.project});

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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProjectDetail(project: project)),
              );
            },
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 0.0, 8.0, 8.0),
                          child: Text(project.title),
                        )
                      ),
                      IconButton(
                        onPressed: () {}, 
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  if (project.image != null) 
                  Column(
                    children: [
                      Divider(height: 1),
                      FittedBox(
                        clipBehavior: Clip.hardEdge,
                        child: Image.file(
                          width: 350,
                          height: 180,
                          File(project.image!),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Divider(height: 1),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text('Stage name'),
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
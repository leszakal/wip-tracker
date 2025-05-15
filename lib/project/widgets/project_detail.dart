import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wip_tracker/interface/delete_dialog.dart';
import '../../stage/data/stage.dart';
import '../../stage/widgets/stage_add.dart';
import '../../stage/widgets/stage_card.dart';
import '../../stage/widgets/stage_card_mini.dart';
import '../data/project.dart';
import '../../storage/local_storage.dart';
import 'project_edit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProjectDetail extends StatefulWidget {
  final int projectId;

  const ProjectDetail({super.key, required this.projectId});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  Project? project;
  List<Stage>? stages;
  Stage? latestStage;
  final _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getProjectById(widget.projectId).then((value) {
        setState(() {
          if (value == null) {
            debugPrint('Project not found');
            return;
          }
          else {
            project = value;
          }
        });
      });
      _localStorage.getStagesForProject(widget.projectId).then((value) {
        setState(() {
          stages = value;
          latestStage = stages![0];
        });
      });
    });
  }

  void _reloadProject() {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getProjectById(project!.id!).then((value) {
        setState(() {
          if (value == null) {
            debugPrint('Project not found');
            return;
          }
          else {
            project = value;
          }
        });
      });
    });
  }

  void _reloadStages() {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getStagesForProject(project!.id!).then((value) {
        setState(() {
          if (value.isEmpty) {
            debugPrint('No stages found');
            return;
          }
          else {
            stages = value;
            latestStage = stages![0];
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(project?.title ?? 'Loading project...'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: BackButton(onPressed: () {
            context.go('/', extra: true);
          }),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Overview'),
              Tab(text: 'Timeline'),
              Tab(text: 'Gallery'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            project == null
            ? Center(child: CircularProgressIndicator()) :
            // Overview
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (project!.image != null)
                    Image.file(
                      latestStage?.image != null
                      ? File(latestStage!.image!)
                      : File(project!.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 16),
                  Text(
                    project!.description != null ? '${project!.description}' : 'No description',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  if (project!.notes != null && project!.notes!.isNotEmpty)
                    Text(
                      'Notes:\n${project!.notes}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  SizedBox(height: 12),
                  Text("Start: ${DateFormat.yMd().format(project!.start)}"),
                  Row(
                    children: [
                      const Text('Tags: '),
                      if (project!.tags == null || project!.tags!.isEmpty)
                        const Text('<None>')
                      else
                        for (int i = 0; i < project!.tags!.length; i++)
                          Text(i != project!.tags!.length - 1
                              ? '${project!.tags![i]}, '
                              : project!.tags![i]),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProjectEdit(project: project!)),
                          );
                          if (result == true) {
                            _reloadProject();
                            _reloadStages();
                          }
                        },
                        child: const Text('edit'),
                      ),
                      DeleteDialog(
                        objectName: project!.title, 
                        onConfirm: () async {
                          await _localStorage.open('wip_tracker.db');
                          await _localStorage.deleteProject(project!.id!);
                          if (context.mounted) {
                            context.pushReplacement('/', extra: true);
                          }
                        }
                      ),
                    ],
                  ),
                  Divider(height: 30.0),
                  Text(
                    'Stages',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  stages == null ?
                  Center(child: CircularProgressIndicator())
                  : stages!.isEmpty ?
                  Text(
                    "No stages yet -- add one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ) 
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: stages!.length,
                    itemBuilder: (context, index) {
                      final stage = stages![index];
                      return Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: StageCardMini(stage: stage),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Timeline
            stages == null
            ? Center(child: CircularProgressIndicator())
            : stages!.isEmpty
            ? Center(
                child: Text(
                  "No stages yet -- add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                itemCount: stages!.length,
                itemBuilder: (context, index) {
                  final stage = stages![index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    child: StageCard(stage: stage),
                  );
                },
              ),

            // Gallery
            stages == null
            ? Center(child: CircularProgressIndicator())
            : stages!.isEmpty
                ? Center(
                    child: Text(
                      "No images to display -- add a stage.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: stages!.length,
                      itemBuilder: (context, index) {
                        final stage = stages![index];
                        if (stage.image == null) {
                          return Container(
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            // Optional: implement full-screen view later
                          },
                          child: ClipRect(
                            child: Image.file(
                              File(stage.image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StageAdd(pid: project!.id!)),
            );
            if (result == true) {
              _reloadStages();
            }
          },
          tooltip: "Add a new project",
          label: const Text('Add Stage'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}

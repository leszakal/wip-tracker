// file: stage_detail.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../interface/delete_dialog.dart';
import '../../stage/data/stage.dart';
import '../../storage/local_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'stage_edit.dart';

class StageDetail extends StatefulWidget {
  final int stageId;

  const StageDetail({super.key, required this.stageId});

  @override
  State<StageDetail> createState() => _StageDetailState();
}

class _StageDetailState extends State<StageDetail> {
  Stage? stage;
  bool initialStage = false;
  bool edited = false;
  final _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getStageById(widget.stageId).then((value) {
        setState(() {
          if (value == null) {
            debugPrint('Stage not found');
            return;
          } else {
            stage = value;
            _localStorage.getInitialStage(stage!.pid).then((value) {
              if (value == widget.stageId) {
                setState(() {
                  initialStage = true;
                });
              }
            });
          }
        });
      });
    });
  }

  void _reloadStage() {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getStageById(widget.stageId).then((value) {
        setState(() {
          if (value == null) {
            debugPrint('Stage not found');
            return;
          } else {
            stage = value;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: stage?.name != "" ? Text(stage?.name ?? 'Loading stage...') : Text('Untitled Stage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: BackButton(
          onPressed: () {
            if (edited) {
              context.goNamed('projects', pathParameters: {'pid': stage!.pid.toString()}, extra: true);
            } else {
              context.goNamed('projects', pathParameters: {'pid': stage!.pid.toString()});
            }
          },
        ),
      ),
      body: stage == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stage!.image != null)
                    Image.file(
                      File(stage!.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 16),
                  Text(
                    stage!.description != null && stage!.description!.isNotEmpty
                        ? '${stage!.description}'
                        : 'No description',
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  if (stage!.notes != null && stage!.notes!.isNotEmpty)
                    Text(
                      'Notes:\n${stage!.notes}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  SizedBox(height: 12),
                  Text("Date: ${DateFormat.yMd().format(stage!.timestamp)}"),
                  if (!initialStage)
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StageEdit(stage: stage!)),
                            );
                            if (result == true) {
                              _reloadStage();
                              setState(() {
                                edited = true;
                              });
                            }
                          },
                          label: const Text('edit'),
                          icon: const Icon(Icons.edit),
                        ),
                        SizedBox(width: 4.0),
                        DeleteDialog(
                          objectName: stage!.name!, 
                          onConfirm: () async {
                            await _localStorage.open('wip_tracker.db');
                            await _localStorage.deleteStage(stage!.id!);
                            if (context.mounted) {
                              context.pushReplacementNamed('projects', pathParameters: {'pid': stage!.pid.toString()}, extra: true);
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

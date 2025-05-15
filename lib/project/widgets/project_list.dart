import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'project_card.dart';

import '../../interface/drawer.dart';
import '../data/project.dart';
import '../../stage/data/stage.dart';
import '../../storage/local_storage.dart';
import 'project_add.dart';

class ProjectList extends StatefulWidget {
  final bool? reload;
  const ProjectList({super.key, this.reload});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<Project>? projects;
  String sortFieldOption = 'lastModified';
  String sortDirectionOption = 'DESC';

  final _localStorage = LocalStorage();

  void _loadProjects([String field = 'lastModified', String sort = 'DESC']) {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.getProjects(field, sort).then((value) {
        setState(() {
          projects = value;
        });
      });
    });
  }

  void _searchProjects(String query) {
    _localStorage.open('wip_tracker.db').then((_) {
      _localStorage.searchProjects(query).then((value) {
        setState(() {
          projects = value;
        });
      });
    });
  }

  @override
  void didUpdateWidget(covariant ProjectList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reload == true && oldWidget.reload != true) {
      _loadProjects();
      setState(() {
        sortFieldOption = 'lastModified';
        sortDirectionOption = 'DESC';
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<Stage?> getLatestStage(Project project) async {
    final latestStage = await _localStorage.getLatestStageObject(project.id!);
    if (latestStage != null) {
      return latestStage;
    } 
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.reload == false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Projects'),
        ),
        drawer: const MyDrawer(currentPage: 1),
        body: Column(
          children: [
            Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search project titles or tags...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  _searchProjects(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: sortFieldOption,
                    underline: Container(height: 2, color: Colors.deepPurpleAccent),
                    onChanged: (value) {
                      setState(() {
                        sortFieldOption = value!;
                      });
                      _loadProjects(sortFieldOption, sortDirectionOption);
                    },
                    items: [
                      DropdownMenuItem(value: 'start', child: Text('Start Date')),
                      DropdownMenuItem(value: 'lastModified', child: Text('Last Modified')),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      sortDirectionOption == 'ASC' ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        sortDirectionOption = sortDirectionOption == 'ASC' ? 'DESC' : 'ASC';
                      });
                      _loadProjects(sortFieldOption, sortDirectionOption);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: projects == null ?
                CircularProgressIndicator()
                : projects!.isEmpty ? 
                Text(
                  "No projects found!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ) 
                : ListView.builder(
                  itemCount: projects!.length,
                  itemBuilder: (context, index) {
                    final project = projects![index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: FutureBuilder(future: getLatestStage(project), builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final latestStage = snapshot.data;
                          return ProjectCard(
                            project: project, 
                            latestStage: latestStage!
                          );
                        }
                        else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } 
                        else {
                          // Placeholder while loading
                          return const SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } 
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProjectAdd()),
            );
            if (result == true) {
              _loadProjects();
            }
          },
          tooltip: "Add a new project",
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
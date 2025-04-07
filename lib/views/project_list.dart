import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'firebasestorage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wip_tracker/views/project_add.dart';

import 'drawer.dart';
import '../models/project.dart';
import '../models/stage.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key, required this.title});
  final String title;

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  File? _image;
  String? _imagePath;
  List<Project>? projects;

  // @override
  // void initState() {
  //   super.initState();
  //   _storage.loadProjects().then((value) {
  //     setState(() {
  //       _imageURL = value;
  //     });
  //   });
  // }

  // Future<void> _getImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  //   if(photo != null) {
  //     if(kIsWeb) {
  //       setState((){
  //         _imagePath = photo.path;
  //       });
  //     } else { // Android camera images
  //       setState((){
  //         _image = File(photo.path);
  //       });
  //     }
  //   } else {
  //     if(kDebugMode){
  //       print('No photo captured');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(currentPage: 1),
      body: Center(
        child: ListView(
           children: <Widget>[
            Text("Placeholder"),
        //     kIsWeb ?
        //     (_imagePath == null
        //       ? const Icon(Icons.photo, size: 100)
        //       : Image.network(_imagePath!, height: 400))
        //      :(_image == null 
        //       ? const Icon(Icons.photo, size: 100)
        //       : Image.file(_image!, height: 300)),
        //     //kIsWeb ? SizedBox.shrink() :
        //     Tooltip(
        //       message: kIsWeb ? 'pick an image from the gallery' : 'launch the camera',
        //       child: ElevatedButton(
        //         onPressed: _getImage,
        //         child: const Icon(Icons.photo_camera),
        //       ),
        //     ),
           ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProjectAdd()),
          );
        },
        tooltip: "Add a new project",
        child: Icon(Icons.add),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'image_placeholder.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  String? _imagePath;

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if(photo != null) {
      setState((){
        _imagePath = null;
        _image = File(photo.path);
      });
    } 
    else {
      if(kDebugMode){
        print('No photo captured');
      }
    }
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if(photo != null) {
      setState((){
        _image = null;
        _imagePath = photo.path;
      });
    } 
    else {
      if(kDebugMode){
        print('No photo captured');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
      child: Column(
        children: [
          if (_image == null && _imagePath == null)
          ImagePlaceholder()
          else if (_image != null)
          Image.file(_image!, height: 300)
          else if (_imagePath != null)
          Image.network(_imagePath!, height:300),

          Padding(padding: EdgeInsets.only(top: 12.0)),
          Row(
            children: [
              Expanded(child: Container()),
              Ink(
                decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.grey[300]),
                child: IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: _uploadImage,
                )
              ),
              Padding(padding: EdgeInsets.only(right: 8.0)),
              if (!kIsWeb)
              Ink(
                decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.deepPurple),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _takePhoto,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatelessWidget {
  final Function onImageSelect;

  const ImageUpload({super.key, required this.onImageSelect});

  Future<void> takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      onImageSelect(photo);
    }
    else {
      if(kDebugMode) {
        print('No photo captured');
      }
    }
  }
  
  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      onImageSelect(photo);
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
          Padding(padding: EdgeInsets.only(top: 12.0)),
          Row(
            children: [
              Expanded(child: Container()),
              Ink(
                decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.grey[300]),
                child: IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: uploadImage,
                )
              ),
              Padding(padding: EdgeInsets.only(right: 8.0)),
              if (!kIsWeb)
              Ink(
                decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.deepPurple),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: takePhoto,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
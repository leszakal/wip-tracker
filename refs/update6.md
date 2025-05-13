## Sites

How to do nested navigation paths:
https://stackoverflow.com/questions/75486115/flutter-nested-navigation-inside-a-page-using-go-router

Extra basic example of the future builder:
https://www.geeksforgeeks.org/flutter-futurebuilder-widget/



## LLM Usage

**-- BEGIN INTERACTION --**

> In flutter, I want to make a gallery with the GridView builder. Could you give me a basic example of how to layout the images?

Sure! Here’s a simple example of how you can create an image gallery using `GridView.builder` in Flutter. This will display a grid of images from a list of image URLs or asset paths.

---

### ✅ Example: Flutter Gallery with `GridView.builder`

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalleryPage(),
    );
  }
}

class GalleryPage extends StatelessWidget {
  final List<String> imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/200',
    'https://via.placeholder.com/250',
    'https://via.placeholder.com/300',
    'https://via.placeholder.com/350',
    'https://via.placeholder.com/400',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
```

---

### ✅ Key Points:

- **GridView.builder**: Efficiently builds only visible items.
    
- **SliverGridDelegateWithFixedCrossAxisCount**: Controls grid layout (columns, spacing).
    
- **ClipRRect**: Adds rounded corners to images.
    
- **BoxFit.cover**: Makes images cover their grid cell properly.
    

---

### ✅ Replace with Assets:

If you're using local assets instead of URLs, replace `Image.network` with:

```dart
Image.asset('assets/images/your_image.png', fit: BoxFit.cover)
```

Make sure to declare assets in `pubspec.yaml`.

---

Would you like me to show you how to add **"onTap to open image in fullscreen view"** when an image is clicked? (Like a gallery viewer)  
Reply with **"Yes, please!"** if you want it. 😊

**-- END INTERACTION --**

**Usage:** Used the basic approach from the example to construct the gallery view for my project.

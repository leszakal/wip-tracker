## Sites

https://stackoverflow.com/questions/56947046/flutter-for-loop-to-generate-list-of-widgets

https://stackoverflow.com/questions/57165310/create-a-datetime-column-in-sqlite-flutter-database

https://medium.com/nerd-for-tech/lifting-state-up-and-callbacks-7a19d0bdbe53

https://stackoverflow.com/questions/51338041/how-to-save-image-file-in-flutter-file-selected-using-image-picker-plugin/51338178

https://stackoverflow.com/questions/50439949/flutter-get-the-filename-of-a-file

## LLM Usage

### Search Engine AI Overviews:

##### Brave search AI overview -- from query 'dart iterate map keys':
"""
In Dart, you can iterate over the keys of a map using several methods. One common approach is to use the `keys` property of the map, which returns an iterable of the map's keys. You can then use a `for-in` loop or the `forEach` method to iterate over these keys.

For example, using a `for-in` loop:

```
for (var k in numMap.keys) {
  print("Key: $k");
}
```

Alternatively, using the `forEach` method:

```
numMap.keys.forEach((k) => print("Key: $k"));
```

Both methods allow you to iterate over the keys of the map without needing to access the values. You can choose the method that best fits your needs based on readability and performance considerations
"""

**Usage**: Used the `map.keys` ways to iterate a map

___

### Chat GPT

#### Question 1:
In flutter, I want to create a two column checklist. I know I could do a row with two columns but is there a better widget for this?

###### ChatGPT said:

Got you — in Flutter, a simple `Row` with two `Column`s would work, _but_ if you're looking for something **nicer** or more **scalable** (especially if your checklist grows), a better option would be to use a **`GridView`**!

Specifically, `GridView.count` can make a **two-column layout** really clean and easy.

Here’s a quick example:

```dart
GridView.count(
  crossAxisCount: 2, // two columns
  shrinkWrap: true,  // so it doesn't take infinite height inside a Column
  physics: NeverScrollableScrollPhysics(), // disable inner scrolling if needed
  childAspectRatio: 4, // adjust height/width ratio of each item
  children: [
    CheckboxListTile(
      title: Text('Option 1'),
      value: true,
      onChanged: (val) {},
    ),
    CheckboxListTile(
      title: Text('Option 2'),
      value: false,
      onChanged: (val) {},
    ),
    // add more checkboxes here
  ],
)
```

**Why `GridView.count`?**

- It automatically wraps your items into a two-column layout.
- It’s easier to maintain than manual `Row`/`Column` nesting when you have a lot of items.
- You get easy scrolling (if needed) and nice spacing.

---

**Bonus tip:** if you want even more control (like uneven-sized items), `GridView` also has a `GridView.builder`, which is even more flexible.

---

Would you like me to show a **fancier** version too? Like, with checkboxes that have custom styles or grouped sections? 🎨✅  
(Depends how fancy you wanna get with your checklist!)

**--END GPT--**

**Usage**: Modeled my checkbox list after the provided code example
___

#### Question 2:

In flutter, I have an image picker widget that is being used in a form. I need to save the selected image upon submitting the form. How should I approach the transfer of the image data between widgets?

###### ChatGPT said:

Nice — working with images inside forms can be super slick once it’s wired up properly.

The best approach for **transferring the image data between widgets**, especially within a form, is to treat the image like any other form field: store it in a **shared state**, and then pass that up when the form is submitted.

Here’s the standard pattern:

---

### ✅ Option 1: **Lift State Up (via Callback or Controller)**

Let your image picker widget **pass the selected image back to the parent** (form screen), and **store it there** for later use (e.g., to save on submit).

---

#### 🧩 Step-by-step:

##### 1. **In your image picker widget:**

```dart
class ImagePickerField extends StatelessWidget {
  final Function(File) onImageSelected;

  ImagePickerField({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Pick Image'),
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);
          onImageSelected(imageFile); // Pass back to parent
        }
      },
    );
  }
}

```

##### 2. **In your form widget (parent):**

```dart
File? _selectedImage;

...

Form(
  child: Column(
    children: [
      ImagePickerField(
        onImageSelected: (image) {
          setState(() {
            _selectedImage = image;
          });
        },
      ),
      ElevatedButton(
        onPressed: () {
          // Save the form and image
          if (_selectedImage != null) {
            // Do something with _selectedImage
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)

```

---

### ✅ Option 2: **Use a Controller or Provider (More Scalable)**

If your form is bigger or you’re managing state across multiple widgets, use a `ChangeNotifier` (via `Provider`) or even something like `FormField<File>` + `Form` + `GlobalKey`.

But for most apps, **Option 1 is clean, simple, and works perfectly.**

---

### Bonus Tip 💾: Storing the Image

Once you’ve got the `File`, you can:

- Save its `path` to a local DB (like sqflite)
    
- Copy it to app documents dir via `path_provider`
    
- Upload it to a server or cloud
    

---

Want an example of saving the image to local storage or maybe displaying it after selection too? Or prefer using something like `FormField` for custom validation?

**-- END GPT --**

**Usage**: Looked more into "lifting state up" and used a similar approach to the provided in the example code to handle my image picking 
## Sites

https://stackoverflow.com/questions/51907936/how-to-show-date-picker-on-the-onclick-of-text-field-instead-of-keyboard-in-flut

https://maxim-gorin.medium.com/flutter-date-and-time-formatting-tips-and-techniques-1011b591384e
## LLM Usage

> If flutter, I want to check if any strings in a list match a string key in a map. How would I do this?

**-- BEGIN RESPONSE --**

In Flutter (Dart), to check if any strings in a `List<String>` match a key in a `Map<String, dynamic>`, you can use the `.any()` method combined with `.containsKey()` on the map.

### Example:

```dart
void main() {
  List<String> stringList = ['apple', 'banana', 'cherry'];
  Map<String, int> myMap = {
    'banana': 1,
    'orange': 2,
    'grape': 3,
  };

  bool hasMatch = stringList.any((item) => myMap.containsKey(item));

  print(hasMatch); // true, because 'banana' is a key in the map
}
```

This returns `true` if **any** string in the list matches a key in the map.

Would you like to also collect all matching keys or just check for existence?

**-- END RESPONSE --**

#### Usage:

Looked more into `mapContains()` and used it to initialize default tags on the edit project page if based on the presence of those tags in the project's tag list.

___
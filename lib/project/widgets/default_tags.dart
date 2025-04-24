import 'package:flutter/material.dart';

class DefaultTagsCheckboxList extends StatelessWidget {
  final Map<String, bool> defaultTags;
  final Function toggleTag;

  const DefaultTagsCheckboxList({
    super.key, 
    required this.defaultTags, 
    required this.toggleTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 4.0),
          child:
            Text(
              'Tags',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 4,
          children: [
            for (String tag in defaultTags.keys)
            CheckboxListTile(
              title: Text(tag),
              value: defaultTags[tag], 
              onChanged: (bool? value) {
                toggleTag(tag);
              },
            ),
          ],
        ),
      ],
    );
  }
}
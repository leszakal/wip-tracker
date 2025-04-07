import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text('Placeholder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          ListTile(
            title: const Text('Projects'),
            onTap: () {
              // Update the state of the app.
              currentPage == 1 ? Navigator.pop(context) : context.go('/');
            },
          ),
        ],
      ),
    );
  }
}

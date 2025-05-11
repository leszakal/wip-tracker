import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wip_tracker/project/data/project.dart';
import 'package:wip_tracker/project/widgets/project_detail.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'project/widgets/project_list.dart';
import 'project/widgets/project_add.dart';
// import 'firebase_options.dart';
// import 'home.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProjectList(),
    ),
    GoRoute(
      path: '/projects/add',
      builder: (context, state) => ProjectAdd(),
    ),
    GoRoute(
      name: 'projects',
      path: '/projects/:id',
      builder: (context, state) {
        final projectId = int.parse(state.pathParameters['id']!);
        return ProjectDetail(projectId: projectId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

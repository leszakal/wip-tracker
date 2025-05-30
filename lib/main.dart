import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wip_tracker/account/widgets/login.dart';
import 'package:wip_tracker/project/widgets/project_detail.dart';
import 'package:firebase_core/firebase_core.dart';

import 'project/widgets/project_list.dart';
import 'stage/widgets/stage_detail.dart';
import 'firebase_options.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        if (state.extra != null) {
          return ProjectList(reload: state.extra as bool);
        }
        else {
          return ProjectList();
        }
      }
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return LoginPage();
      }
    ),
    GoRoute(
      name: 'projects',
      path: '/projects/:pid',
      builder: (context, state) {
        final projectId = int.parse(state.pathParameters['pid']!);
        if (state.extra == true) {
          return ProjectDetail(projectId: projectId, reload: true);
        }
        return ProjectDetail(projectId: projectId);
      },
      routes: [
        GoRoute(
          name: 'stages',
          path: 'stages/:sid',
          builder: (context, state) {
            final stageId = int.parse(state.pathParameters['sid']!);
            return StageDetail(stageId: stageId);
          },
        ),
      ]
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

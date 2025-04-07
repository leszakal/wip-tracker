import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'views/project_list.dart';
import 'views/project_add.dart';
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
      builder: (context, state) => const ProjectList(title: 'Projects'),
    ),
    GoRoute(
      path: '/add-project',
      builder: (context, state) => const ProjectAdd(),
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

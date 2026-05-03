import 'package:daily_notes/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/controller/main_controller/main_controller.dart';
import 'features/auth/presentation/controller/auth_controller.dart';
import 'features/home_screen/presentation/controller/note_controller.dart';
import 'routes/apps_routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register controllers after Firebase is initialized.
  Get.put<AppController>(AppController(), permanent: true);
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<NotesController>(NotesController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

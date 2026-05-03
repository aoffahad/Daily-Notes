import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

import '../data/controller/main_controller/main_controller.dart';
import '../features/auth/presentation/controller/auth_controller.dart';
import '../features/auth/presentation/page/signup_screen.dart';
import '../features/home_screen/presentation/controller/note_controller.dart';
import '../features/home_screen/presentation/page/add_note_screen.dart';
import '../features/home_screen/presentation/page/home_page.dart';
import '../features/home_screen/presentation/page/note_details_screen.dart';
import '../features/onboarding/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/page/login_scree.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final appController = Get.find<AppController>();
        final auth = Get.find<AuthController>();

        return Obx(() {
          if (appController.isFirstLaunch.value) {
            return const OnboardingPage();
          }

          if (auth.user.value == null) {
            return LoginPage();
          }

          return HomePage();
        });
      },
    ),

    GoRoute(path: '/login', builder: (context, state) =>  LoginPage()),

    GoRoute(
      path: '/register',
      builder: (context, state) =>  RegisterPage(),
    ),

    GoRoute(
      path: '/home-page',
      builder: (context, state) => HomePage(),
    ),

    GoRoute(
      path: '/add-note',
      builder: (context, state) => AddNotePage(),
    ),

    GoRoute(
      path: '/add-note/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final controller = Get.find<NotesController>();

        final note = controller.notes.firstWhereOrNull((n) => n.id == id);

        if (note == null) {
          return const Scaffold(
            body: Center(child: Text("Note not found")),
          );
        }

        return AddNotePage(note: note);
      },
    ),

    GoRoute(
      path: '/note-details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NoteDetailsPage(noteId: id);
      },
    ),
  ],
);

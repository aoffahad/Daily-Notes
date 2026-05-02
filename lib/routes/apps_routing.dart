import 'package:daily_notes/features/home_screen/data/note_model.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

import '../data/controller/main_controller/main_controller.dart';
import '../features/auth/presentation/page/signup_screen.dart';
import '../features/home_screen/presentation/controller/note_controller.dart';
import '../features/home_screen/presentation/page/add_note_screen.dart';
import '../features/home_screen/presentation/page/home_page.dart';
import '../features/home_screen/presentation/page/note_details_screen.dart';
import '../features/onboarding/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/page/login_scree.dart';

final appController = Get.put(AppController());

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Obx(() {
          return appController.isFirstLaunch.value
              ? const OnboardingPage()
              : const LoginPage();
        });
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/home-page', builder: (context, state) => HomePage()),
   GoRoute(
  path: '/add-note',
  builder: (context, state) => AddNotePage(),
),

GoRoute(
  path: '/add-note/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];

    final controller = Get.find<NotesController>();

    final note = controller.notes.firstWhere((n) => n.id == id);

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

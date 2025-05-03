import 'package:go_router/go_router.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/error/error_page.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';
import 'package:language_app/modules/navigation/navigation_view.dart';
import 'package:language_app/modules/profile/profile_view.dart';

final goRouter = GoRouter(initialLocation: "/home", routes: [
  //Child: the selected widget in the `route` list
  ShellRoute(
      builder: (context, state, child) => NavigationPage(
            child: child,
          ),
      routes: [
        GoRoute(
          path: "/home",
          builder: (context, state) => HomePage(unit: dummyUnits.first),
        ),
        GoRoute(
          path: "/profile",
          builder: (context, state) => ProfileView(),
        )
      ]),
  GoRoute(
    path: "/lesson/:id",
    builder: (context, state) {
      final id = int.tryParse(state.pathParameters["id"] ?? "");
      if (id == null) {
        return ErrorPage(error: Exception("Lesson id not found"));
      }
      return LessonPage(
        lessonId: id,
      );
    },
  ),
]);

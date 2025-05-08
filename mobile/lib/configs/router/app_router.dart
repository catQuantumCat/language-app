import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/auth/login/login_view.dart';
import 'package:language_app/modules/auth/register/register_view.dart';
import 'package:language_app/modules/error/error_page.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/language_selection/language_selection_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';
import 'package:language_app/modules/navigation/navigation_view.dart';
import 'package:language_app/modules/profile/profile_view.dart';
import 'package:language_app/utils/stream_to_listenable.dart';

enum AppRoute {
  login("/login"),
  register("/register"),
  languageSelection("/language-selection"),
  home("/home"),
  profile("/profile");

  final String path;

  const AppRoute(this.path);
}

final class AppRouter {
  final AuthBloc authBloc;
  AppRouter._(this.authBloc);
  static GoRouter? _router;

  GoRouter get router => _router ??= _getRouter();

  factory AppRouter({required AuthBloc authBloc}) => AppRouter._(authBloc);

  GoRouter _getRouter() {
    return GoRouter(
      refreshListenable: StreamToListenable([authBloc.stream]),
      redirect: _handleRedirect,
      initialLocation: AppRoute.login.path,
      routes: _buildRoutes(),
    );
  }

  Future<String?> _handleRedirect(
      BuildContext context, GoRouterState state) async {
    final bool isAuthenticated =
        authBloc.state.status == AppStateEnum.authenticated;

    final bool isAuthPath = (state.matchedLocation == AppRoute.login.path ||
        state.matchedLocation == AppRoute.register.path);

    // If on the language selection path, don't redirect
    if (state.matchedLocation == AppRoute.languageSelection.path) {
      return null;
    }

    // List of protected routes that require authentication
    final List<String> protectedRoutes = [
      AppRoute.home.path,
      AppRoute.profile.path
    ];

    if (isAuthenticated && isAuthPath) {
      final languageRepo = getIt<LanguageRepo>();
      try {
        bool hasLanguages = await languageRepo.hasUserLanguages();
        if (!hasLanguages) {
          return AppRoute.languageSelection.path;
        }

        return AppRoute.home.path;
      } catch (e) {
        log('Error checking user languages: $e');

        return AppRoute.home.path;
      }
    }

    if (!isAuthenticated && protectedRoutes.contains(state.matchedLocation)) {
      return AppRoute.login.path;
    }
    return null;
  }

  List<RouteBase> _buildRoutes() {
    return [
      // Auth routes
      ShellRoute(
          builder: (context, state, child) => Scaffold(body: child),
          routes: [
            GoRoute(
              path: AppRoute.login.path,
              builder: (context, state) => LoginPage(),
            ),
            GoRoute(
              path: AppRoute.register.path,
              builder: (context, state) => RegisterPage(),
            ),
            GoRoute(
              path: AppRoute.languageSelection.path,
              builder: (context, state) => LanguageSelectionPage(),
            )
          ]),
      // Main navigation routes with StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationPage(
            child: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                builder: (context, state) => HomePage(unit: dummyUnits.first),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile.path,
                builder: (context, state) => ProfileView(),
              ),
            ],
          ),
        ],
      ),
      // Lesson route
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
    ];
  }
}

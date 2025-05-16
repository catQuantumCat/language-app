// configs/router/app_router.dart (chỉ sửa phần import)
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/auth/login/login_view.dart';
import 'package:language_app/modules/auth/register/register_view.dart';
import 'package:language_app/modules/error/error_page.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/knowledge/knowledge_view.dart';
import 'package:language_app/modules/knowledge/lessons_view.dart';
import 'package:language_app/modules/knowledge/units_view.dart';
import 'package:language_app/modules/language_selection/language_selection_view.dart';
import 'package:language_app/modules/leaderboard/leaderboard_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';
import 'package:language_app/modules/mistakes/mistake_detail_view.dart';
import 'package:language_app/modules/mistakes/mistakes_view.dart';
import 'package:language_app/modules/navigation/navigation_view.dart';
import 'package:language_app/modules/profile/profile_view.dart';
import 'package:language_app/utils/stream_to_listenable.dart';

// Cập nhật enum AppRoute trong app_router.dart
enum AppRoute {
  login("/login"),
  register("/register"),
  languageSelection("/language-selection"),
  home("/home"),
  leaderboard("/leaderboard"),
  mistakes("/mistakes"),
  mistakeDetail("/mistakes/:id"),
  units("/units"), // Thêm route mới
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
      AppRoute.profile.path,
      // Add other protected routes if needed
    ];

    if (isAuthenticated && isAuthPath) {
      // User is authenticated but on an auth page, check if they have languages
      final userRepo = getIt<UserRepo>();
      final user = await userRepo.getUserInfo();

      if (user != null && (user.languages.isEmpty)) {
        return AppRoute.languageSelection.path;
      }

      // User has languages, redirect to home
      return AppRoute.home.path;
    }

    if (!isAuthenticated && protectedRoutes.contains(state.matchedLocation)) {
      // User is not authenticated but trying to access protected route
      return AppRoute.login.path;
    }

    return null;
  }

  // Future<String?> _handleRedirect(
  //     BuildContext context, GoRouterState state) async {
  //   final bool isAuthenticated =
  //       authBloc.state.status == AppStateEnum.authenticated;

  //   final bool isAuthPath = (state.matchedLocation == AppRoute.login.path ||
  //       state.matchedLocation == AppRoute.register.path);

  //   // If on the language selection path, don't redirect
  //   if (state.matchedLocation == AppRoute.languageSelection.path) {
  //     return null;
  //   }

  //   // List of protected routes that require authentication
  //   final List<String> protectedRoutes = [
  //     AppRoute.home.path,
  //     AppRoute.profile.path
  //   ];

  //   if (isAuthenticated && isAuthPath) {
  //     final languageRepo = getIt<LanguageRepo>();
  //     try {
  //       bool hasLanguages = await languageRepo.hasUserLanguages();
  //       if (!hasLanguages) {
  //         return AppRoute.languageSelection.path;
  //       }

  //       return AppRoute.home.path;
  //     } catch (e) {
  //       log('Error checking user languages: $e' as num);

  //       return AppRoute.home.path;
  //     }
  //   }

  //   if (!isAuthenticated && protectedRoutes.contains(state.matchedLocation)) {
  //     return AppRoute.login.path;
  //   }
  //   return null;
  // }

  List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: "/units",
        builder: (context, state) => UnitsPage(),
      ),
      GoRoute(
        path: "/units/:unitId/lessons",
        builder: (context, state) {
          final unitId = state.pathParameters["unitId"];
          final unitTitle = state.uri.queryParameters["unitTitle"];
          final unitOrder =
              int.tryParse(state.uri.queryParameters["unitOrder"] ?? "");

          if (unitId == null) {
            return ErrorPage(error: Exception("Unit ID not found"));
          }

          return LessonsPage(
              unitId: unitId,
              unitTitle: unitTitle ?? "Unit",
              unitOrder: unitOrder ?? 0);
        },
      ),
      GoRoute(
        path: "/lessons/:lessonId/knowledge",
        builder: (context, state) {
          final lessonId = state.pathParameters["lessonId"];
          final lessonTitle = state.uri.queryParameters["lessonTitle"];

          if (lessonId == null) {
            return ErrorPage(error: Exception("Lesson ID not found"));
          }

          return KnowledgePage(
              lessonId: lessonId, lessonTitle: lessonTitle ?? "Lesson");
        },
      ),
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
              builder: (context, state) {
                final fromHome = state.extra != null &&
                        (state.extra as Map).containsKey('fromHome')
                    ? (state.extra as Map)['fromHome'] as bool
                    : false;
                return LanguageSelectionPage(fromHome: fromHome);
              },
            )
          ]),
      // Main navigation routes with StatefulShellRoute
      // Cập nhật phần StatefulShellRoute trong _buildRoutes()
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
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.leaderboard.path,
                builder: (context, state) => LeaderboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.mistakes.path,
                builder: (context, state) => MistakesPage(),
              ),
              GoRoute(
                path: AppRoute.mistakeDetail.path,
                builder: (context, state) {
                  final id = state.pathParameters["id"];
                  if (id == null) {
                    return ErrorPage(error: Exception("Mistake ID not found"));
                  }
                  return MistakeDetailPage(mistakeId: id);
                },
              ),
            ],
          ),
          // Thêm branch mới cho Knowledge
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/units",
                builder: (context, state) => UnitsPage(),
              ),
              GoRoute(
                path: "/units/:unitId/lessons",
                builder: (context, state) {
                  final unitId = state.pathParameters["unitId"];
                  final unitTitle = state.uri.queryParameters["unitTitle"];
                  final unitOrder = int.tryParse(
                      state.uri.queryParameters["unitOrder"] ?? "");

                  if (unitId == null) {
                    return ErrorPage(error: Exception("Unit ID not found"));
                  }

                  return LessonsPage(
                      unitId: unitId,
                      unitTitle: unitTitle ?? "Unit",
                      unitOrder: unitOrder ?? 0);
                },
              ),
              GoRoute(
                path: "/lessons/:lessonId/knowledge",
                builder: (context, state) {
                  final lessonId = state.pathParameters["lessonId"];
                  final lessonTitle = state.uri.queryParameters["lessonTitle"];

                  if (lessonId == null) {
                    return ErrorPage(error: Exception("Lesson ID not found"));
                  }

                  return KnowledgePage(
                      lessonId: lessonId, lessonTitle: lessonTitle ?? "Lesson");
                },
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
        path: "/lesson/:languageId/:unitId/:lessonId",
        builder: (context, state) {
          final unitId = state.pathParameters["unitId"];
          final lessonId = state.pathParameters["lessonId"];
          final languageId = state.pathParameters["languageId"];
          if (unitId == null || lessonId == null || languageId == null) {
            return ErrorPage(
                error: Exception("Unit ID or Lesson ID not found"));
          }
          return LessonPage(
            languageId: languageId,
            unitId: unitId,
            lessonId: lessonId,
          );
        },
      ),
    ];
  }
}

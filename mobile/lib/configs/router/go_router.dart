import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/auth/login/login_view.dart';
import 'package:language_app/modules/auth/register/register_view.dart';
import 'package:language_app/modules/error/error_page.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/lesson/lesson_view.dart';
import 'package:language_app/modules/navigation/navigation_view.dart';
import 'package:language_app/modules/profile/profile_view.dart';
import 'package:language_app/utils/stream_to_listenable.dart';

abstract class AppRouter {
  static GoRouter getRouter(AuthBloc authBloc) => GoRouter(
          refreshListenable: StreamToListenable([authBloc.stream]),
          redirect: (context, state) {
            final bool isAuthenticated =
                authBloc.state.status == AuthStatus.authenticated;

            final bool isAuthPath = state.matchedLocation == '/login' ||
                state.matchedLocation == '/register';

            // List of protected routes that require authentication
            final List<String> protectedRoutes = ['/home', '/profile'];

            // Only redirect if on an auth path when authenticated or trying to access a protected route when not authenticated
            // This allows the lesson route to be preserved during hot reload

            // If authenticated but on an auth path -> home path
            if (isAuthenticated && isAuthPath) {
              return "/home";
            }

            // If not authenticated and on a protected path -> login path
            if (!isAuthenticated &&
                protectedRoutes.contains(state.matchedLocation)) {
              return "/login";
            }

            // Otherwise, don't redirect, preserving the current route
            return null;
          },
          initialLocation: "/login",
          routes: [
            // Auth routes
            ShellRoute(
                builder: (context, state, child) => Scaffold(body: child),
                routes: [
                  GoRoute(
                    path: "/login",
                    builder: (context, state) => LoginPage(),
                  ),
                  GoRoute(
                    path: "/register",
                    builder: (context, state) => RegisterPage(),
                  )
                ]),
            // Main navigation routes
            ShellRoute(
                builder: (context, state, child) => NavigationPage(
                      child: child,
                    ),
                routes: [
                  GoRoute(
                    path: "/home",
                    builder: (context, state) =>
                        HomePage(unit: dummyUnits.first),
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
}

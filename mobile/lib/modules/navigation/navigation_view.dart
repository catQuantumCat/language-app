// navigation_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return NavigationView(child: child);
  }
}

class NavigationView extends StatelessWidget {
  const NavigationView({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorTheme.border,
              width: 4,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: context.colorTheme.background,
          selectedIndex: child.currentIndex,
          onDestinationSelected: (index) {
            child.goBranch(index);
          },
          height: 60,
          indicatorColor: context.colorTheme.onSelection,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.error_outline),
              label: 'Mistakes',
            ),
            NavigationDestination(
              icon: Icon(Icons.book), // Icon mới cho Knowledge
              label: 'Knowledge',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

// navigation_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NavigationView(child: child);
  }
}

class NavigationView extends StatelessWidget {
  const NavigationView({super.key, required this.child});

  final Widget child;

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
          selectedIndex: _getSelectedIndex(context),
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/leaderboard');
                break;
              case 2:
                context.go('/mistakes');
                break;
              case 3:
                context.go('/units'); // Thêm tab mới cho Knowledge
                break;
              case 4:
                context.go('/profile');
                break;
            }
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
  
  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/leaderboard')) return 1;
    if (location.startsWith('/mistakes')) return 2;
    if (location.startsWith('/units') || location.startsWith('/lessons')) return 3; // Cập nhật điều kiện
    if (location.startsWith('/profile')) return 4;
    return 0;
  }
}

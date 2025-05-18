// navigation_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/gen/assets.gen.dart';

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
              width: 2,
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
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                Assets.navigationIcons.navHome.path,
                width: 24,
                height: 24,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.navigationIcons.navGraph.path,
                width: 24,
                height: 24,
              ),
              label: 'Leaderboard',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.navigationIcons.navRemove.path,
                width: 24,
                height: 24,
              ),
              label: 'Mistakes',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.navigationIcons.navInfo.path,
                width: 24,
                height: 24,
              ),
              label: 'Knowledge',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.navigationIcons.navUser.path,
                width: 24,
                height: 24,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';

import 'package:language_app/modules/navigation/cubit/navigation_cubit.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocListener<NavigationCubit, NavigationState>(
        listener: (context, state) {
          GoRouter.of(context).go(state.path);
        },
        child: NavigationView(
          child: child,
        ),
      ),
    );
  }
}

class NavigationView extends StatelessWidget {
  const NavigationView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
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
              selectedIndex: context.read<NavigationCubit>().state.getIndex(),
              onDestinationSelected: (index) {
                context.read<NavigationCubit>().navigateToIndex(index: index);
              },
              height: 60,
              indicatorColor: context.colorTheme.onSelection,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
          body: child,
        );
      },
    );
  }
}

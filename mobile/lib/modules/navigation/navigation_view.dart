import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/navigation/cubit/navigation_cubit.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: NavigationView(),
    );
  }
}

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return NavigationBar(
            selectedIndex: context.read<NavigationCubit>().state.index,
            onDestinationSelected: (index) =>
                context.read<NavigationCubit>().navigateToIndex(index: index),
            height: 72,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            ],
          );
        },
      ),
      body: SafeArea(child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.index,
            children: [
              HomePage(unit: dummyUnits.first),
              Placeholder(),
            ],
          );
        },
      )),
    );
  }
}

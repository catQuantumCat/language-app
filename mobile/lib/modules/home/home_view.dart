import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/domain/models/lesson.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/gen/assets.gen.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/home/bloc/home_bloc.dart';
import 'package:language_app/modules/home/widgets/header_widget.dart';
import 'package:language_app/modules/home/widgets/info_row.dart';

import 'package:language_app/modules/home/widgets/unit_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeView(
        unit: unit,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.unit});

  final Unit unit;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //Dummy list for units
  final List<List<int>> numbers = [
    List<int>.generate(12, (index) => index),
    List<int>.generate(18, (index) => index),
    List<int>.generate(20, (index) => index),
  ];

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onPositionChange);
  }

  void _onPositionChange() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstVisibleIndex = positions.first.index;
      if (firstVisibleIndex != _currentIndexNotifier.value) {
        _currentIndexNotifier.value = firstVisibleIndex;
      }
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onPositionChange);
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  void navigateToLesson(BuildContext context, {Lesson? lesson}) {
    if (lesson == null) {
      return;
    }

    GoRouter.of(context).go("/lesson/1");
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.read<AuthBloc>().state.user;
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 20),

      //TODO: fetch logic
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: 8),
              InfoRow(
                  countryFlag: Assets.france.svg(),
                  hasTodayStreak: true,
                  heartCount: 3,
                  streakCount: 2),
              SizedBox(height: 8),
              HeaderWidget(unitIndex: _currentIndexNotifier),
              Expanded(
                  child: UnitList(
                      units: state.units,
                      itemPositionsListener: itemPositionsListener))
            ],
          );
        },
      ),
    );
  }
}

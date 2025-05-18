import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/constants/view_state_enum.dart';
import 'package:language_app/domain/models/lesson.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/domain/use_cases/home_screen_fetch_use_case.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/home/bloc/home_bloc.dart';
import 'package:language_app/modules/home/widgets/header_widget.dart';
import 'package:language_app/modules/home/widgets/info_row.dart';

import 'package:language_app/modules/home/widgets/unit_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
          homeScreenFetchUseCase: getIt<HomeScreenFetchUseCase>(),
          userRepo: getIt<UserRepo>()),
      child: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onPositionChange);

    // Reload units when returning to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(LoadUnits());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload units when this page becomes visible again
    // context.read<HomeBloc>().add(LoadMetadataEvent());
    context.read<HomeBloc>().add(LoadUnits());
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
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.initial:
              return const SizedBox.shrink();
            case ViewStateEnum.loading:
              return Center(child: const CircularProgressIndicator());
            case ViewStateEnum.failed:
              return const Center(child: Text("failed"));
            case ViewStateEnum.succeed:
              return _buildHomeBody(state);
          }
        },
      ),
    );
  }

  Widget _buildHomeBody(HomeState state) {
    return Column(
      children: [
        SizedBox(height: 8),
        InfoRow(
            language: state.language,
            hasTodayStreak: true,
            heartCount: state.heartCount,
            streakCount: state.streakCount),
        SizedBox(height: 8),
        HeaderWidget(
            unitIndex: _currentIndexNotifier,
            rawUnitIndex: state.language?.unitOrder ?? 0),
        Expanded(
          child: UnitList(
              languageId: state.language?.languageId ?? "",
              units: state.units,
              itemPositionsListener: itemPositionsListener,
              currentUnitIndex: state.language?.unitOrder ?? 0,
              currentLessonIndex: state.language?.lessonOrder ?? 0),
        )
      ],
    );
  }
}

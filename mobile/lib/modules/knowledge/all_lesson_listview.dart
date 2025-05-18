import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/knowledge/bloc/lessons_bloc.dart';

class AllLessonListPage extends StatefulWidget {
  final String unitId;
  final String unitTitle;
  final int unitOrder;

  const AllLessonListPage({
    super.key,
    required this.unitId,
    required this.unitTitle,
    required this.unitOrder,
  });

  @override
  State<AllLessonListPage> createState() => _AllLessonListPageState();
}

class _AllLessonListPageState extends State<AllLessonListPage> {
  late final LessonsBloc _lessonsBloc;
  bool _initialized = false;

  @override
  void initState() {
    _lessonsBloc = LessonsBloc(
      knowledgeRepo: getIt<KnowledgeRepo>(),
    );

    if (!_initialized) {
      _lessonsBloc.add(LoadLessonsEvent(
        unitId: widget.unitId,
        unitTitle: widget.unitTitle,
        unitOrder: widget.unitOrder,
      ));
      _initialized = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    log('dispose');
    _lessonsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _lessonsBloc,
      child: const AllLessonListView(),
    );
  }
}

class AllLessonListView extends StatelessWidget {
  const AllLessonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorTheme.background,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: BlocBuilder<LessonsBloc, LessonsState>(
          builder: (context, state) {
            return Text(
              state.unitTitle != null
                  ? 'Unit ${state.unitOrder}: ${state.unitTitle}'
                  : 'Danh sách bài học',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<LessonsBloc, LessonsState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewStateEnum.succeed:
              return _buildLessonsList(context, state);
            case ViewStateEnum.failed:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không thể tải danh sách bài học',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Đã xảy ra lỗi',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.colorTheme.error,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (state.unitId != null) {
                          context.read<LessonsBloc>().add(LoadLessonsEvent(
                                unitId: state.unitId!,
                                unitTitle: state.unitTitle ?? '',
                                unitOrder: state.unitOrder ?? 0,
                              ));
                        } else {
                          context.pop();
                        }
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context, LessonsState state) {
    if (state.lessons.isEmpty) {
      return Center(
        child: Text(
          'Không có bài học nào',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    // Sắp xếp bài học theo thứ tự
    final sortedLessons = List<LessonResponse>.from(state.lessons)
      ..sort((a, b) => a.order.compareTo(b.order));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedLessons.length,
      itemBuilder: (context, index) {
        final lesson = sortedLessons[index];
        return Card(
          color: context.colorTheme.background,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () => _navigateToKnowledge(context, lesson),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: context.colorTheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${lesson.order}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: context.colorTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bài ${lesson.order}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        Text(
                          lesson.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: context.colorTheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToKnowledge(BuildContext context, LessonResponse lesson) {
    context.push(
      '/lessons/${lesson.id}/knowledge?lessonTitle=${Uri.encodeComponent(lesson.title)}',
    );
  }
}

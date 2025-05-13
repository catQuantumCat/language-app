import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/knowledge/bloc/lessons_bloc.dart';

class LessonsPage extends StatelessWidget {
  final String unitId;
  final String unitTitle;
  final int unitOrder;

  const LessonsPage({
    super.key,
    required this.unitId,
    required this.unitTitle,
    required this.unitOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonsBloc(
        knowledgeRepo: getIt<KnowledgeRepo>(),
      )..add(LoadLessonsEvent(
          unitId: unitId,
          unitTitle: unitTitle,
          unitOrder: unitOrder,
        )),
      child: const LessonsView(),
    );
  }
}

class LessonsView extends StatelessWidget {
  const LessonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LessonsBloc, LessonsState>(
          builder: (context, state) {
            return Text(
              state.unitTitle != null
                  ? 'Unit ${state.unitOrder}: ${state.unitTitle}'
                  : 'Danh sách bài học',
            );
          },
        ),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/units'),
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
                          context.go('/units');
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
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Text(
                          lesson.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: context.colorTheme.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${lesson.experienceReward} XP',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.colorTheme.warning,
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              lesson.progress.completed
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: lesson.progress.completed
                                  ? context.colorTheme.correct
                                  : Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lesson.progress.completed ? 'Hoàn thành' : 'Chưa hoàn thành',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: lesson.progress.completed
                                        ? context.colorTheme.correct
                                        : Colors.grey,
                                  ),
                            ),
                          ],
                        ),
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
  context.go(
    '/lessons/${lesson.id}/knowledge?lessonTitle=${Uri.encodeComponent(lesson.title)}',
  );
}
}

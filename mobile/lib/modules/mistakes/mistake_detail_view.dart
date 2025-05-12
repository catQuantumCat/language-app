// modules/mistakes/mistake_detail_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/models/challenge_data.dart';

import 'package:language_app/domain/repos/mistake_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/challenge/base_challenge_widget.dart';
import 'package:language_app/modules/lesson/bloc/lesson_bloc.dart';
import 'package:language_app/modules/mistakes/bloc/mistake_detail_bloc.dart';

class MistakeDetailPage extends StatelessWidget {
  final String mistakeId;

  const MistakeDetailPage({
    super.key,
    required this.mistakeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MistakeDetailBloc(
        mistakeRepo: getIt<MistakeRepo>(),
      )..add(LoadMistakeDetailEvent(mistakeId)),
      child: const MistakeDetailView(),
    );
  }
}

class MistakeDetailView extends StatelessWidget {
  const MistakeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Lỗi Sai'),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/mistakes'),
        ),
      ),
      body: BlocBuilder<MistakeDetailBloc, MistakeDetailState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewStateEnum.succeed:
              if (state.mistakeDetail == null) {
                return const Center(child: Text('Không tìm thấy chi tiết lỗi sai'));
              }
              return _buildMistakeDetail(context, state);
            case ViewStateEnum.failed:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không thể tải chi tiết lỗi sai',
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
                        context.go('/mistakes');
                      },
                      child: const Text('Quay lại'),
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

  Widget _buildMistakeDetail(BuildContext context, MistakeDetailState state) {
  final mistakeDetail = state.mistakeDetail!;
  final challenge = mistakeDetail.exercise;
  
  return Column(
    children: [
      // Thông tin bài học
      Container(
        padding: const EdgeInsets.all(16),
        color: context.colorTheme.background,
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: context.colorTheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mistakeDetail.unitName != null)
                    Text(
                      'Unit ${mistakeDetail.unitOrder}: ${mistakeDetail.unitName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    'Bài ${mistakeDetail.lessonOrder}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Hiển thị thông tin chi tiết về challenge nếu là translateWritten
      if (challenge.exerciseType == ExerciseType.translateWritten)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hướng dẫn: ${challenge.instruction}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Từ cần dịch: ${(challenge.data as TranslateChallengeData).translateWord}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Đáp án đúng: ${(challenge.data as TranslateChallengeData).acceptedAnswer.join(", ")}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      
      // Hiển thị câu hỏi
      Expanded(
        child: ChallengeWidgetFactory.produce(
          key: ValueKey(challenge.id),
          challenge: challenge,
          onAnswerTapped: (_) {
            // Chỉ hiển thị, không xử lý đáp án
            context.go('/mistakes');
          },
          answerStatus: AnswerStatus.none,
        ),
      ),
      
      // Nút quay lại
      Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => context.go('/mistakes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorTheme.primary,
            foregroundColor: context.colorTheme.onPrimary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Quay lại danh sách'),
        ),
      ),
    ],
  );
}

}

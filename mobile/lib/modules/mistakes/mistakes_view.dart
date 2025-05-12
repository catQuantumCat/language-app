// modules/mistakes/mistakes_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/mistake_entry.dart';
import 'package:language_app/domain/repos/mistake_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/mistakes/bloc/mistakes_bloc.dart';

class MistakesPage extends StatelessWidget {
  const MistakesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MistakesBloc(
        mistakeRepo: getIt<MistakeRepo>(),
        userRepo: getIt<UserRepo>(),
      )..add(LoadMistakesEvent()),
      child: const MistakesView(),
    );
  }
}

class MistakesView extends StatelessWidget {
  const MistakesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Lỗi Sai'),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
      ),
      body: BlocBuilder<MistakesBloc, MistakesState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewStateEnum.succeed:
              return state.mistakes.isEmpty
                  ? _buildEmptyState(context)
                  : _buildMistakesList(context, state);
            case ViewStateEnum.failed:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không thể tải danh sách lỗi sai',
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
                        context.read<MistakesBloc>().add(LoadMistakesEvent());
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: context.colorTheme.correct,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có lỗi sai nào',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tiếp tục học để giữ thành tích này nhé!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMistakesList(BuildContext context, MistakesState state) {
    // Nhóm các lỗi sai theo ngày
    final Map<String, List<MistakeEntry>> groupedMistakes = {};
    
    for (var mistake in state.mistakes) {
      final date = _formatDate(mistake.createdAt);
      if (!groupedMistakes.containsKey(date)) {
        groupedMistakes[date] = [];
      }
      groupedMistakes[date]!.add(mistake);
    }

    final sortedDates = groupedMistakes.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sắp xếp ngày mới nhất lên đầu

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final mistakes = groupedMistakes[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                date,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...mistakes.map((mistake) => _buildMistakeItem(context, mistake)).toList(),
            if (index < sortedDates.length - 1)
              const Divider(height: 32, thickness: 1),
          ],
        );
      },
    );
  }

  Widget _buildMistakeItem(BuildContext context, MistakeEntry mistake) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _navigateToMistakeDetail(context, mistake),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorTheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Bài ${mistake.lessonOrder}',
                      style: TextStyle(
                        color: context.colorTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (mistake.unitName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colorTheme.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        mistake.unitName!,
                        style: TextStyle(
                          color: context.colorTheme.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    _formatTime(mistake.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mistake.instruction,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (mistake.question != null) ...[
                const SizedBox(height: 4),
                Text(
                  mistake.question!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      color: context.colorTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: context.colorTheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMistakeDetail(BuildContext context, MistakeEntry mistake) {
    context.go('/mistakes/${mistake.id}');
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Hôm nay';
    } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
      return 'Hôm qua';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _formatTime(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('HH:mm').format(date);
  }
}

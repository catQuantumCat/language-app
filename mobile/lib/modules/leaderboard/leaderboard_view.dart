// modules/leaderboard/leaderboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/leaderboard_entry.dart';
import 'package:language_app/domain/repos/leaderboard_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/leaderboard/bloc/leaderboard_bloc.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepo: getIt<LeaderboardRepo>(),
        userRepo: getIt<UserRepo>(),
      )..add(LoadLeaderboardEvent()),
      child: const LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Xếp Hạng'),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
      ),
      body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewStateEnum.succeed:
              return _buildLeaderboardList(context, state);
            case ViewStateEnum.failed:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không thể tải bảng xếp hạng',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LeaderboardBloc>().add(LoadLeaderboardEvent());
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

  Widget _buildLeaderboardList(BuildContext context, LeaderboardState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: state.leaderboardEntries.length,
            itemBuilder: (context, index) {
              final entry = state.leaderboardEntries[index];
              final isCurrentUser = state.currentUserRank != null && 
                  entry.userId == state.currentUserRank!.userId;
                  
              return _buildLeaderboardItem(context, entry, isCurrentUser);
            },
          ),
        ),
        if (state.currentUserRank != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorTheme.onSelection.withOpacity(0.3),
              border: Border(
                top: BorderSide(color: context.colorTheme.border),
              ),
            ),
            child: _buildLeaderboardItem(
              context, 
              state.currentUserRank!, 
              true,
              showDivider: false,
            ),
          ),
      ],
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context, 
    LeaderboardEntry entry, 
    bool isCurrentUser,
    {bool showDivider = true}
  ) {
    return Container(
      color: isCurrentUser ? context.colorTheme.onSelection.withOpacity(0.3) : null,
      child: Column(
        children: [
          ListTile(
            leading: _buildRankWidget(context, entry.rank),
            title: Text(
              entry.fullName,
              style: TextStyle(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text('@${entry.username}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: context.colorTheme.warning,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${entry.experience}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildRankWidget(BuildContext context, int rank) {
    Color backgroundColor;
    Color textColor = context.colorTheme.onPrimary;
    
    // Màu sắc cho các hạng cao nhất
    switch (rank) {
      case 1:
        backgroundColor = Colors.amber; // Vàng
        break;
      case 2:
        backgroundColor = Colors.grey.shade300; // Bạc
        break;
      case 3:
        backgroundColor = Colors.brown.shade300; // Đồng
        break;
      default:
        backgroundColor = context.colorTheme.primary;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

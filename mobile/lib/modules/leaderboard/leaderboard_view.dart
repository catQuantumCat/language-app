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
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Bảng Xếp Hạng',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        backgroundColor: context.colorTheme.background,
        foregroundColor: Colors.black,
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
                        context
                            .read<LeaderboardBloc>()
                            .add(LoadLeaderboardEvent());
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
    final topThree = state.leaderboardEntries.take(3).toList();
    final restOfEntries = state.leaderboardEntries.skip(3).toList();

    return Column(
      children: [
        if (topThree.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: context.colorTheme.background,
              boxShadow: [
                BoxShadow(
                  color: context.colorTheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (topThree.length > 1)
                  Expanded(
                    child: _buildPodiumItem(
                      context,
                      topThree[1],
                      2,
                      isSecond: true,
                    ),
                  ),
                if (topThree.isNotEmpty)
                  Expanded(
                    child: _buildPodiumItem(
                      context,
                      topThree[0],
                      1,
                      isFirst: true,
                    ),
                  ),
                if (topThree.length > 2)
                  Expanded(
                    child: _buildPodiumItem(
                      context,
                      topThree[2],
                      3,
                      isThird: true,
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: restOfEntries.length,
            itemBuilder: (context, index) {
              final entry = restOfEntries[index];
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
              color: context.colorTheme.onSelection.withValues(alpha: 0.3),
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

  Widget _buildPodiumItem(
    BuildContext context,
    LeaderboardEntry entry,
    int rank, {
    bool isFirst = false,
    bool isSecond = false,
    bool isThird = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorTheme.background,
                boxShadow: [
                  BoxShadow(
                    color: context.colorTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: isFirst
                      ? Colors.amber
                      : isSecond
                          ? Colors.grey.shade300
                          : Colors.brown.shade300,
                  width: 3,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor:
                      context.colorTheme.primary.withValues(alpha: 0.1),
                  child: entry.avatar != null && entry.avatar!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            entry.avatar!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 40,
                              color: context.colorTheme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: context.colorTheme.primary,
                        ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFirst
                      ? Colors.amber
                      : isSecond
                          ? Colors.grey.shade300
                          : Colors.brown.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: context.colorTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      color: context.colorTheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isFirst
                ? Colors.amber.withValues(alpha: 0.2)
                : isSecond
                    ? Colors.grey.shade300.withValues(alpha: 0.2)
                    : Colors.brown.shade300.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                entry.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.colorTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: context.colorTheme.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${entry.experience}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.colorTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(
      BuildContext context, LeaderboardEntry entry, bool isCurrentUser,
      {bool showDivider = true}) {
    return Container(
      color: isCurrentUser
          ? context.colorTheme.onSelection.withValues(alpha: 0.3)
          : null,
      child: Column(
        children: [
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    '${entry.rank}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorTheme.background,
                    boxShadow: [
                      BoxShadow(
                        color:
                            context.colorTheme.primary.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        context.colorTheme.primary.withValues(alpha: 0.1),
                    child: entry.avatar != null && entry.avatar!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              entry.avatar!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.person,
                                size: 24,
                                color: context.colorTheme.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 24,
                            color: context.colorTheme.primary,
                          ),
                  ),
                ),
              ],
            ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
}

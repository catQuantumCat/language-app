import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/gen/assets.gen.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/profile/bloc/profile_bloc.dart';
import 'package:language_app/modules/profile/bloc/profile_event.dart';
import 'package:language_app/modules/profile/bloc/profile_state.dart';
import 'package:language_app/modules/profile/widgets/overview_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(userRepo: GetIt.instance<UserRepo>())
        ..add(const LoadUserProfile()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoadFailure) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state is ProfileLoadSuccess) {
          return _profileBodyBuilder(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Scaffold _profileBodyBuilder(BuildContext context, ProfileLoadSuccess state) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoHeaderBuilder(state, context),
              const SizedBox(height: 24),
              _overviewBuilder(context, state),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _onLogoutTapped(context),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewBuilder(BuildContext context, ProfileLoadSuccess state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Overview',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 8),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        childAspectRatio: 16 / 9,
        children: [
          OverviewCard(
            icon: Image.asset(
              Assets.streakFire.path,
              scale: 20,
            ),
            value: state.user.streak.toString(),
            label: 'Day streak',
          ),
          OverviewCard(
            icon: Assets.heart.svg(),
            value: state.user.hearts.toString(),
            label: 'Hearts',
          ),
          OverviewCard(
            icon: Icon(
              Icons.flash_on,
              color: context.colorTheme.selection,
            ),
            value: state.user.experience.toString(),
            label: 'Total XP',
          ),
          OverviewCard(
            icon: Icon(
              Icons.public,
              color: context.colorTheme.warning,
            ),
            value: "${state.user.languages.length}",
            label: 'Languages',
          ),
        ],
      )
    ]);
  }

  Widget _infoHeaderBuilder(ProfileLoadSuccess state, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.user.fullName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  "@${state.user.username}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(width: 8),
                Icon(Icons.email, size: 16),
                const SizedBox(width: 4),
                Text(
                  state.user.email,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 16),
        state.user.avatar != null
            ? CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(state.user.avatar!),
              )
            : Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
      ],
    );
  }

  void _onLogoutTapped(BuildContext context) {
    context.read<AuthBloc>().add(LogOutEvent());
  }
}

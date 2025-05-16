import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/language_selection/bloc/language_selection_bloc.dart';

class LanguageSelectionPage extends StatelessWidget {
  final bool fromHome;

  const LanguageSelectionPage({
    super.key,
    this.fromHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageSelectionBloc(
        languageRepo: getIt<LanguageRepo>(),
      )..add(const LoadLanguagesEvent()),
      child: LanguageSelectionView(fromHome: fromHome),
    );
  }
}

class LanguageSelectionView extends StatelessWidget {
  final bool fromHome;

  const LanguageSelectionView({
    super.key,
    this.fromHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.background,
      appBar: AppBar(
        title: const Text('Select a Language'),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
        automaticallyImplyLeading: fromHome,
      ),
      body: BlocConsumer<LanguageSelectionBloc, LanguageSelectionState>(
        listener: (context, state) {
          if (state is LanguageSelectionLoadedState &&
              state.status == LanguageSelectionStatus.success) {
            // Navigate to home page on success
            context.go('/home');
          } else if (state is LanguageSelectionErrorState ||
              (state is LanguageSelectionLoadedState &&
                  state.status == LanguageSelectionStatus.error)) {
            // Show error message
            final errorMessage = state is LanguageSelectionErrorState
                ? state.errorMessage
                : (state as LanguageSelectionLoadedState).errorMessage ??
                    'An error occurred';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: context.colorTheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LanguageSelectionLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LanguageSelectionLoadedState) {
            return _buildLanguageSelectionList(context, state);
          } else if (state is LanguageSelectionErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load languages',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LanguageSelectionBloc>().add(
                            const LoadLanguagesEvent(),
                          );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLanguageSelectionList(
    BuildContext context,
    LanguageSelectionLoadedState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Choose a language to start learning',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: state.availableLanguages.length,
            itemBuilder: (context, index) {
              final language = state.availableLanguages[index];
              final isSelected = language.id == state.selectedLanguageId;

              return _buildLanguageItem(
                context,
                language,
                isSelected,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: state.status == LanguageSelectionStatus.submitting
                ? null
                : () {
                    context.read<LanguageSelectionBloc>().add(
                          const SubmitSelectedLanguageEvent(),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorTheme.primary,
              foregroundColor: context.colorTheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: state.status == LanguageSelectionStatus.submitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.colorTheme.onPrimary,
                      ),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    AvailableLanguage language,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: context.colorTheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          context.read<LanguageSelectionBloc>().add(
                SelectLanguageEvent(language.id),
              );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              language.flagUrl != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(language.flagUrl!),
                    )
                  : Center(
                      child: Text(
                        language.code.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  language.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: context.colorTheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

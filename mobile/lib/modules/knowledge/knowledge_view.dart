import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/knowledge_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';
import 'package:language_app/main.dart';
import 'package:language_app/modules/challenge/widgets/audio_widget.dart';
import 'package:language_app/modules/knowledge/bloc/knowledge_bloc.dart';

class KnowledgePage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;

  const KnowledgePage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late final KnowledgeBloc _knowledgeBloc;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _knowledgeBloc = KnowledgeBloc(knowledgeRepo: getIt<KnowledgeRepo>());

    if (!_initialized) {
      _knowledgeBloc.add(LoadKnowledgeEvent(
        lessonId: widget.lessonId,
        lessonTitle: widget.lessonTitle,
      ));
      _initialized = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    _knowledgeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _knowledgeBloc,
      child: const KnowledgeView(),
    );
  }
}

class KnowledgeView extends StatelessWidget {
  const KnowledgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<KnowledgeBloc, KnowledgeState>(
          builder: (context, state) {
            return Text(state.lessonTitle ?? 'Kiến thức');
          },
        ),
        backgroundColor: context.colorTheme.primary,
        foregroundColor: context.colorTheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<KnowledgeBloc, KnowledgeState>(
        builder: (context, state) {
          switch (state.viewState) {
            case ViewStateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewStateEnum.succeed:
              return _buildKnowledgeContent(context, state);
            case ViewStateEnum.failed:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Không thể tải kiến thức',
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
                        if (state.lessonId != null) {
                          context.read<KnowledgeBloc>().add(LoadKnowledgeEvent(
                                lessonId: state.lessonId!,
                                lessonTitle: state.lessonTitle ?? '',
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

  Widget _buildKnowledgeContent(BuildContext context, KnowledgeState state) {
    if (state.knowledgeItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Không có kiến thức nào',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      );
    }

    final currentItem = state.currentItem;
    if (currentItem == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: currentItem.type == KnowledgeItemType.vocabulary
                ? _buildVocabularyCard(context, currentItem.data as Vocabulary)
                : _buildGrammarCard(context, currentItem.data as Grammar),
          ),
        ),
        _buildNavigationButtons(context, state),
      ],
    );
  }

  Widget _buildVocabularyCard(BuildContext context, Vocabulary vocabulary) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.colorTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Từ vựng',
                    style: TextStyle(
                      color: context.colorTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    vocabulary.englishWord,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (vocabulary.audioUrl.isNotEmpty)
                  AudioWidget(using: vocabulary.audioUrl),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              vocabulary.pronunciation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nghĩa:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              vocabulary.vietnameseMeaning,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (vocabulary.examples.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Ví dụ:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...vocabulary.examples
                  .map((example) => _buildExampleItem(context, example)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGrammarCard(BuildContext context, Grammar grammar) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.colorTheme.selection.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Ngữ pháp',
                    style: TextStyle(
                      color: context.colorTheme.selection,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              grammar.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              grammar.explanation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (grammar.examples.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Ví dụ:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...grammar.examples
                  .map((example) => _buildExampleItem(context, example)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(BuildContext context, Example example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.english,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: context.colorTheme.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            example.vietnamese,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, KnowledgeState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!state.isFirstItem)
            ElevatedButton.icon(
              onPressed: () {
                context.read<KnowledgeBloc>().add(PreviousKnowledgeItemEvent());
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Trước'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            )
          else
            const SizedBox(width: 100),
          Text(
            '${state.currentItemIndex! + 1}/${state.knowledgeItems.length}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (!state.isLastItem)
            ElevatedButton.icon(
              onPressed: () {
                context.read<KnowledgeBloc>().add(NextKnowledgeItemEvent());
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Tiếp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorTheme.primary,
                foregroundColor: context.colorTheme.onPrimary,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.check),
              label: const Text('Hoàn thành'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorTheme.correct,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

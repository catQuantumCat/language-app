import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class CompletionWidget extends StatelessWidget {
  const CompletionWidget({
    super.key,
    this.message,
    required this.onContinueTapped,
    required this.time,
    required this.xp,
    required this.accuracy,
  });

  final String? message;
  final VoidCallback onContinueTapped;
  final Duration time;
  final int xp;
  final double accuracy;

  String get formattedTime {
    final minutes = time.inMinutes;
    final seconds = time.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  String get formattedAccuracy => '${(accuracy * 100).toStringAsFixed(0)}%';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Trophy image or celebration image
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorTheme.primary.withAlpha(127)),
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 100,
                color: context.colorTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Congratulation text
          Text(
            "Lesson completed",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'You\'ve completed the lesson',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 32),

          // Metrics section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colorTheme.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMetricRow(
                  context,
                  icon: Icons.timer,
                  title: 'Time',
                  value: formattedTime,
                ),
                const Divider(height: 24),
                _buildMetricRow(
                  context,
                  icon: Icons.star,
                  title: 'XP Earned',
                  value: '+$xp XP',
                ),
                const Divider(height: 24),
                _buildMetricRow(
                  context,
                  icon: Icons.check_circle,
                  title: 'Accuracy',
                  value: formattedAccuracy,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Continue button
          ElevatedButton(
            onPressed: onContinueTapped,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: context.colorTheme.primary,
              foregroundColor: context.colorTheme.onPrimary,
            ),
            child: Text(
              'Continue',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.colorTheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorTheme.selection.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: context.colorTheme.selection,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

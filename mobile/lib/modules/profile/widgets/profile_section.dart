// modules/profile/widgets/profile_section.dart
import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

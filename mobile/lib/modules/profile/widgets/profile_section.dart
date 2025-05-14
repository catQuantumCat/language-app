// modules/profile/widgets/profile_section.dart
import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSection({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colorTheme.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

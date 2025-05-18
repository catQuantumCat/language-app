// modules/profile/widgets/stats_card.dart
import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const StatsCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorTheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //       child: Column(
  //         children: [
  //           Icon(
  //             icon,
  //             color: iconColor,
  //             size: 28,
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: Theme.of(context).textTheme.titleLarge?.copyWith(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             title,
  //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                   color: Colors.grey[600],
  //                 ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

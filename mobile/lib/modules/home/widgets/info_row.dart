import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/domain/models/language.dart';
import 'package:language_app/gen/assets.gen.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.streakCount,
    required this.heartCount,
    required this.xpCount,
    required this.hasTodayStreak,
    required this.language,
  });

  final Language? language;
  final int streakCount;
  final int heartCount;
  final int xpCount;
  final bool hasTodayStreak;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () {
          context.go('/language-selection', extra: {'fromHome': true});
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: ClipOval(
            child: language?.languageFlag != null &&
                    language!.languageFlag.isNotEmpty
                ? Image.network(
                    language!.languageFlag,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(language!.languageId
                            .substring(0, 2)
                            .toUpperCase())),
                  )
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                          language!.languageId.substring(0, 2).toUpperCase()),
                    ),
                  ), // Fallback to a default flag
          ),
        ),
      ),
      Row(
        children: [
          Text(
            "$streakCount",
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 6),
          SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(hasTodayStreak
                  ? Assets.streakFire.path
                  : Assets.streakFireBlack.path))
        ],
      ),
      Row(
        children: [
          Text(
            "$heartCount",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 6),
          Assets.heart.svg()
        ],
      ),
      Row(
        children: [
          Text(
            "$xpCount XP",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ]);
  }
}

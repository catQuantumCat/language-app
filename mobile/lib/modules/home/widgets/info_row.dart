import 'package:flutter/material.dart';
import 'package:language_app/gen/assets.gen.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.countryFlag,
    required this.streakCount,
    required this.heartCount,
    required this.hasTodayStreak,
  });

  final Widget countryFlag;

  final int streakCount;
  final int heartCount;

  final bool hasTodayStreak;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(width: 32, height: 32, child: countryFlag),
      Row(
        children: [
          Text("$streakCount"),
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
        children: [Text("$heartCount"), SizedBox(width: 6), Assets.heart.svg()],
      ),
    ]);
  }
}

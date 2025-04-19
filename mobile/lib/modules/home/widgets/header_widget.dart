import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.currentIndexNotifier,
  });

  final ValueNotifier<int> currentIndexNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return Text("${currentIndex + 1}",
                    style: TextStyle(fontSize: 20));
              }),
          // Text("Unit ${widget.unit.id}", style: TextStyle(fontSize: 20)),
          // Text(widget.unit.title,
          //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

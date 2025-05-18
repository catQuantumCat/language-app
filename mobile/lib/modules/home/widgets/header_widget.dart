import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/modules/home/bloc/home_bloc.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.unitIndex,
    required this.rawUnitIndex,
  });

  final int rawUnitIndex;

  final ValueNotifier<int> unitIndex;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: unitIndex,
        builder: (context, currentIndex, _) {
          return Container(
            decoration: BoxDecoration(
                color: currentIndex < rawUnitIndex
                    ? context.colorTheme.primary
                    : Colors.grey,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: getIndex(context),
            ),
          );
        });
  }

  Widget getIndex(BuildContext context) {
    final homeState = context.read<HomeBloc>().state;

    return ValueListenableBuilder<int>(
        valueListenable: unitIndex,
        builder: (context, currentIndex, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: currentIndex >= homeState.units.length
                ? [Text("No info about this unit")]
                : [
                    Text(
                      "Unit ${homeState.units[currentIndex].order}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      homeState.units[currentIndex].title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge_data.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

// ignore: must_be_immutable
class PairMatchingChallengeWidget extends BaseChallengeWidget<bool> {
  PairMatchingChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.answerStatus});

  @override
  Widget bodyWidgetBuilder() {
    return PairChoices(
      onAnswerTapped: onAnswerTapped,
      challengeData: ((challenge.data) as PairMatchingChallengeData),
    );
  }
}

class PairChoices extends StatefulWidget {
  const PairChoices(
      {super.key, required this.onAnswerTapped, required this.challengeData});

  final void Function(bool) onAnswerTapped;

  final PairMatchingChallengeData challengeData;

  @override
  State<PairChoices> createState() => _PairChoicesState();
}

class _PairChoicesState extends State<PairChoices> {
  late List<PairMatchingOption> leftOptions;
  late List<PairMatchingOption> rightOptions;

  Set<PairMatchingOption> selectedOptions = {};

  PairMatchingOption? selectedLeft;
  PairMatchingOption? selectedRight;
  

  @override
  void initState() {
    super.initState();

    leftOptions = widget.challengeData.options
        .where((option) => option.column == PairMachingEnum.left)
        .toList();
    rightOptions = widget.challengeData.options
        .where((option) => option.column == PairMachingEnum.right)
        .toList();
  }

  void _onPairTapped(PairMatchingOption selectedOption) {
    switch (selectedOption.column) {
      case PairMachingEnum.left:
        setState(() {
          selectedLeft =
              (selectedLeft == selectedOption) ? null : selectedOption;
        });
        break;
      case PairMachingEnum.right:
        setState(() {
          selectedRight =
              (selectedRight == selectedOption) ? null : selectedOption;
        });
        break;
    }

    if (selectedLeft == null || selectedRight == null) return;

    if (_checkLocalPair()) {
      setState(() {
        selectedOptions.addAll({selectedLeft!, selectedRight!});
      });

      _hasFinished();
    }

    setState(() {
      selectedLeft = null;
      selectedRight = null;
    });
  }

  bool _checkLocalPair() {
    if (selectedLeft == null || selectedRight == null) return false;

    return (widget.challengeData.checkPair(selectedLeft!, selectedRight!));
  }

  void _hasFinished() {
    if (selectedOptions.length != widget.challengeData.options.length) return;

    widget.onAnswerTapped(true);
  }

  Widget _columnBuilder({required List<PairMatchingOption> using}) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: using
          .map((option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                            _getColor(of: option))),
                    onPressed: selectedOptions.contains(option) == true
                        ? null
                        : () => _onPairTapped(option),
                    child: Text(option.text)),
              ))
          .toList(),
    ));
  }

  Color _getColor({required PairMatchingOption of}) {
    if (selectedOptions.contains(of)) {
      return Colors.grey;
    }

    if ((selectedLeft != null && of.id == selectedLeft!.id) ||
        (selectedRight != null && of.id == selectedRight!.id)) {
      return Colors.cyanAccent;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          _columnBuilder(using: leftOptions),
          SizedBox(width: 12),
          _columnBuilder(using: rightOptions),
        ],
      ),
    );
  }
}

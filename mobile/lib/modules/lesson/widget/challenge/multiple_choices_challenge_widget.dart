import 'package:flutter/material.dart';
import 'package:language_app/data/models/challenge_data.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/modules/lesson/widget/challenge/base_challenge_widget.dart';

// ignore: must_be_immutable
class MultipleChoicesChallengeWidget
    extends BaseChallengeWidget<ChallengeOption> {
  MultipleChoicesChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.answerStatus});

  void _onSelectionTapped(ChallengeOption option) {
    super.currentAnswer = option;
  }

  @override
  Widget bodyWidgetBuilder() {
    return ChoiceList(
          choicesData: super.challenge.data as MultipleChoiceChallengeData,
          onSelected: (choice) => _onSelectionTapped(choice),
        );
  }
}

class ChoiceList extends StatefulWidget {
  const ChoiceList(
      {super.key, required this.choicesData, required this.onSelected});

  final MultipleChoiceChallengeData choicesData;
  final void Function(ChallengeOption) onSelected;

  @override
  State<ChoiceList> createState() => _ChoiceListState();
}

class _ChoiceListState extends State<ChoiceList> {
  ChallengeOption? currentlySelectedOption;

  void _onSelectionTapped(ChallengeOption? value) {
    if (value == null) return;
    setState(() {
      currentlySelectedOption = value;
    });
    widget.onSelected(value);
  }

  Widget photoChoices() {
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: widget.choicesData.options
            .map(
              (option) => InkWell(
                onTap: () {
                  _onSelectionTapped(option);
                },
                child: Container(
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Text(option.text),
                        Expanded(
                          child: Image.asset(
                            option.imageUrl ?? "assets/duck.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget textChoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.choicesData.options.length,
        (index) => ListTile(
            title: Text(widget.choicesData.options[index].text),
            leading: Radio<ChallengeOption>(
              groupValue: currentlySelectedOption,
              value: widget.choicesData.options[index],
              onChanged: (value) {
                _onSelectionTapped(value);
              },
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.choicesData.options[0].imageUrl == null
        ? textChoices()
        : photoChoices();
  }
}

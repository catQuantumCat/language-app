import 'package:flutter/material.dart';
import 'package:language_app/common/extensions/context_extension.dart';
import 'package:language_app/domain/models/challenge_data.dart';
import 'package:language_app/domain/models/challenge_option.dart';
import 'package:language_app/modules/challenge/base_challenge_widget.dart';

// ignore: must_be_immutable
class SentenceOrderChallengeWidget
    extends BaseChallengeWidget<List<SentenceOrderOption>> {
  SentenceOrderChallengeWidget(
      {super.key,
      required super.challenge,
      required super.onAnswerTapped,
      required super.answerStatus});

  void _updateValues(List<SentenceOrderOption> values) {
    currentAnswer.value = values;
  }

  @override
  Widget bodyWidgetBuilder() {
    final SentenceOrderChallengeData data =
        challenge.data as SentenceOrderChallengeData;
    return DraggableChoices(
      options: data.options,
      updateValues: (values) => _updateValues(values),
    );
  }
}

class DraggableChoices extends StatefulWidget {
  DraggableChoices(
      {super.key,
      required List<SentenceOrderOption> options,
      required this.updateValues})
      : optionMapping = {for (var op in options) op: false};

  final Function(List<SentenceOrderOption>) updateValues;
  final Map<SentenceOrderOption, bool> optionMapping;

  @override
  State<DraggableChoices> createState() => _DraggableChoicesState();
}

class _DraggableChoicesState extends State<DraggableChoices> {
  List<SentenceOrderOption> selectedOptions = [];

  void _removeFromTarget(SentenceOrderOption option) {
    if (widget.optionMapping[option] == false) return;

    setState(() {
      widget.optionMapping[option] = false;
      selectedOptions.removeWhere((o) => o.id == option.id);
    });

    widget.updateValues(selectedOptions);
  }

  void _addToTarget(SentenceOrderOption option) {
    if (widget.optionMapping[option] == true) return;

    widget.optionMapping[option] = true;
    setState(() {
      selectedOptions.add(option);
    });

    widget.updateValues(selectedOptions);
  }

  Widget _optionCell(String text, {void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: context.customButtomTheme.filledButton,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _dropTargetBuilder(),
        SizedBox(height: 8),
        _draggableOptionsBuilder()
      ],
    );
  }

  Wrap _draggableOptionsBuilder() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: widget.optionMapping.keys
          .map<Widget>((option) => Draggable(
                data: option,
                maxSimultaneousDrags:
                    widget.optionMapping[option] == true ? 0 : 1,
                feedback: _optionCell(
                  option.text,
                ),
                child: _optionCell(
                  option.text,
                  onPressed: widget.optionMapping[option] == true
                      ? null
                      : () => _addToTarget(option),
                ),
              ))
          .toList(),
    );
  }

  Expanded _dropTargetBuilder() {
    return Expanded(
      child: DragTarget<SentenceOrderOption>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return selectedOptions.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(16)),
                  height: 50,
                  child: Center(
                    child: Text(
                      'Drag options here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: selectedOptions
                        .map<Widget>((option) => Draggable(
                              data: option,
                              feedback: _optionCell(
                                option.text,
                              ),
                              child: _optionCell(
                                option.text,
                                onPressed: () => _removeFromTarget(option),
                              ),
                            ))
                        .toList(),
                  ),
                );
        },
        onLeave: (option) => {
          if (option != null) {_removeFromTarget(option)}
        },
        onAcceptWithDetails: (DragTargetDetails<SentenceOrderOption> details) {
          _addToTarget(details.data);
        },
      ),
    );
  }
}

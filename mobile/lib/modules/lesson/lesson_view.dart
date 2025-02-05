import 'package:flutter/material.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LessonView();
  }
}

class LessonView extends StatefulWidget {
  const LessonView({super.key});

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  var currentQuestionIndex = 0;
  var numOfHeart = 3;

  final List<String> questions = [
    "What are you going to do?",
    "Where are you from?",
    "How old are you?",
    "What is your name?",
    "What is your favorite color?",
  ];

  final List<List<String>> possibleAnswers = [
    ["going", "doing", "making", "planning"],
    ["from", "to", "in", "at"],
    ["old", "young", "years", "age"],
    ["name", "called", "known", "titled"],
    ["color", "food", "hobby", "sport"],
  ];

  final List<int> correctAnswerIndex = [0, 0, 0, 0, 0];

  void _exit(BuildContext context) {
    Navigator.pop(context);
  }

  void _answerCorrect() {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: Text("Correct"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
                _continueTapped();
              },
              child: Text("Continue"))
        ],
      ),
    );
  }

  void _answerIncorrect() {
    setState(() {
      numOfHeart--;
    });
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: Text("Incorrect"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
                _continueTapped();
              },
              child: Text("Continue"))
        ],
      ),
    );
  }

  void _answerTapped(int answerIndex) {
    correctAnswerIndex[currentQuestionIndex] == answerIndex
        ? _answerCorrect()
        : _answerIncorrect();
  }

  void _finishLesson({required bool isNoHeartLeft}) {
    String dialogTitle =
        !isNoHeartLeft ? "Lesson completed" : "You have no heart left";

    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: Text(dialogTitle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(alertContext);
              _exit(context);
            },
            child: Text("Return home"),
          )
        ],
      ),
    );
  }

  void _continueTapped() {
    if (currentQuestionIndex >= questions.length - 1 || numOfHeart == 0) {
      _finishLesson(isNoHeartLeft: numOfHeart == 0);
      return;
    }
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _exit(context),
                      icon: const Icon(Icons.clear),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("Q: ${currentQuestionIndex + 1}/${questions.length}"),
                  ],
                ),
                Text("$numOfHeart hearts left"),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fill in the blank",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                SizedBox(height: 2),
                Text(questions[currentQuestionIndex],
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                possibleAnswers[currentQuestionIndex].length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    onPressed: () => _answerTapped(index),
                    child: Text(possibleAnswers[currentQuestionIndex][index]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(onPressed: () {}, child: Text("Continue"))
          ],
        ),
      ),
    );
  }
}

import 'package:language_app/data/models/unit.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/data/models/challenge_option.dart';

List<MultipleChoiceOption> dummyChallengeOptions = [
  MultipleChoiceOption(
      id: "1", exerciseId: "1", correct: true, text: 'Option 1'),
  MultipleChoiceOption(
      id: "2", exerciseId: "1", correct: false, text: 'Option 2'),
  MultipleChoiceOption(
      id: "3", exerciseId: "1", correct: true, text: 'Option 3'),
  MultipleChoiceOption(
      id: "4", exerciseId: "1", correct: false, text: 'Option 4'),
  MultipleChoiceOption(
      id: "90",
      exerciseId: "2",
      correct: true,
      text: 'Option 3',
      imageUrl: 'assets/duck.jpg'),
  MultipleChoiceOption(
      id: "100",
      exerciseId: "2",
      correct: false,
      text: 'Option 4',
      imageUrl: 'assets/scence.JPG'),
];

List<SentenceOrderOption> dummyOrderOptions = [
  SentenceOrderOption(id: "0", exerciseId: "0", text: 'One', order: 0),
  SentenceOrderOption(id: "1", exerciseId: "0", text: 'Two', order: 1),
  SentenceOrderOption(id: "2", exerciseId: "0", text: 'Three', order: 2),
  SentenceOrderOption(id: "3", exerciseId: "0", text: 'Option with', order: 3),
  SentenceOrderOption(
      id: "4", exerciseId: "0", text: 'Another option', order: 4),
  SentenceOrderOption(id: "5", exerciseId: "0", text: 'Yet ', order: 5),
  SentenceOrderOption(id: "6", exerciseId: "0", text: 'A very long', order: 6),
];

List<PairMatchingOption> dummyPairMatchingOptions = [
  PairMatchingOption(
      id: "1",
      exerciseId: "3",
      text: 'Pair 1',
      pairId: 1,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: "2",
      exerciseId: "3",
      text: 'Pair 2',
      pairId: 1,
      column: PairMachingEnum.right),
  PairMatchingOption(
      id: "3",
      exerciseId: "3",
      text: 'Pair 3',
      pairId: 2,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: "4",
      exerciseId: "3",
      text: 'Pair 4',
      pairId: 2,
      column: PairMachingEnum.right),
  PairMatchingOption(
      id: "5",
      exerciseId: "3",
      text: 'Pair 5',
      pairId: 3,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: "6",
      exerciseId: "3",
      text: 'Pair 6',
      pairId: 3,
      column: PairMachingEnum.right),
];

List<Challenge> get dummyChallenges {
  final List<Challenge> challenges = [];
  // jsonDecode(dummyJsonData).forEach((d) {
  //   challenges.add(Challenge.fromJson(d));
  // });
  return challenges;
}

// List<Challenge> dummyChallenges = [
//   Challenge(
//       id: "-1",
//       order: -1,
//       question: 'Pair matching',
//       data: PairMatchingChallengeData(
//         options: dummyPairMatchingOptions
//             .where((option) => option.exerciseId == "3")
//             .toList(),
//       ),
//       exerciseType: ExerciseType.pairMatching),
//   Challenge(
//       id: "2",
//       order: 2,
//       question: 'What is 2 + 2?',
//       data: MultipleChoiceChallengeData(
//         options: dummyChallengeOptions
//             .where((option) => option.exerciseId == "1")
//             .toList(),
//       ),
//       exerciseType: ExerciseType.multipleChoice),
//   Challenge(
//       id: "0",
//       order: 0,
//       question: "Sentence order, length of 3",
//       data: SentenceOrderChallengeData(
//           options: dummyOrderOptions, optionLength: 3),
//       exerciseType: ExerciseType.sentenceOrder),
//   Challenge(
//       id: "1",
//       order: 1,
//       question: 'Translate the word "Hello"',
//       data: TranslateChallengeData(acceptedAnswer: ['hello']),
//       exerciseType: ExerciseType.translateWritten),
//   Challenge(
//       id: "3",
//       order: 3,
//       question: 'Translate the word "World"',
//       data: TranslateChallengeData(acceptedAnswer: ['world']),
//       exerciseType: ExerciseType.translateWritten),
//   Challenge(
//       id: "4",
//       order: 4,
//       question: 'Select the correct option - multiple choices',
//       data: MultipleChoiceChallengeData(
//         options: dummyChallengeOptions
//             .where((option) => option.exerciseId == "2")
//             .toList(),
//       ),
//       exerciseType: ExerciseType.multipleChoice),
// ];

List<Lesson> dummyLessons = [
  Lesson(
    id: 1,
    unitId: 1,
    title: 'Introduction to Geography',
    order: 5,
    challenges: dummyChallenges
        .where((challenge) => challenge.lessonId == "1")
        .toList(),
  ),
];

List<Unit> dummyUnits = [
  Unit(
    id: 1,
    title: 'Basic Knowledge',
    description: 'This unit covers basic knowledge topics.',
    order: 1,
    lessons: dummyLessons.where((lesson) => lesson.unitId == 1).toList(),
  ),
];

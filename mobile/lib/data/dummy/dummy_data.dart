import 'package:language_app/data/models/unit.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/data/models/challenge_data.dart';

List<MultipleChoiceOption> dummyChallengeOptions = [
  MultipleChoiceOption(id: 1, challengeId: 1, correct: true, text: 'Option 1'),
  MultipleChoiceOption(id: 2, challengeId: 1, correct: false, text: 'Option 2'),
  MultipleChoiceOption(id: 3, challengeId: 1, correct: true, text: 'Option 3'),
  MultipleChoiceOption(id: 4, challengeId: 1, correct: false, text: 'Option 4'),
  MultipleChoiceOption(
      id: 90,
      challengeId: 2,
      correct: true,
      text: 'Option 3',
      imageUrl: 'assets/duck.jpg'),
  MultipleChoiceOption(
      id: 100,
      challengeId: 2,
      correct: false,
      text: 'Option 4',
      imageUrl: 'assets/scence.JPG'),
];

List<ChallengeOption> dummyOrderOptions = [
  ChallengeOption(id: 0, challengeId: 0, text: 'One'),
  ChallengeOption(id: 1, challengeId: 0, text: 'Two'),
  ChallengeOption(id: 2, challengeId: 0, text: 'Three'),
  ChallengeOption(id: 3, challengeId: 0, text: 'Option with'),
  ChallengeOption(id: 4, challengeId: 0, text: 'Another option'),
  ChallengeOption(id: 5, challengeId: 0, text: 'Yet '),
  ChallengeOption(id: 6, challengeId: 0, text: 'A very long'),
];

List<PairMatchingOption> dummyPairMatchingOptions = [
  PairMatchingOption(
      id: 1,
      challengeId: 3,
      text: 'Pair 1',
      pairId: 1,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: 2,
      challengeId: 3,
      text: 'Pair 2',
      pairId: 1,
      column: PairMachingEnum.right),
  PairMatchingOption(
      id: 3,
      challengeId: 3,
      text: 'Pair 3',
      pairId: 2,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: 4,
      challengeId: 3,
      text: 'Pair 4',
      pairId: 2,
      column: PairMachingEnum.right),
  PairMatchingOption(
      id: 5,
      challengeId: 3,
      text: 'Pair 5',
      pairId: 3,
      column: PairMachingEnum.left),
  PairMatchingOption(
      id: 6,
      challengeId: 3,
      text: 'Pair 6',
      pairId: 3,
      column: PairMachingEnum.right),
];

List<Challenge> dummyChallenges = [
  Challenge(
      id: -1,
      lessonId: 1,
      order: -1,
      question: 'Pair matching',
      data: PairMatchingChallengeData(
        options: dummyPairMatchingOptions
            .where((option) => option.challengeId == 3)
            .toList(),
      ),
      type: ChallengeType.pairMatching),
  Challenge(
      id: 2,
      lessonId: 1,
      order: 2,
      question: 'What is 2 + 2?',
      data: MultipleChoiceChallengeData(
        options: dummyChallengeOptions
            .where((option) => option.challengeId == 1)
            .toList(),
      ),
      type: ChallengeType.multipleChoice),
  Challenge(
      id: 0,
      lessonId: 1,
      order: 0,
      question: "Sentence order, length of 3",
      data: SentenceOrderChallengeData(
          options: dummyOrderOptions, optionLength: 3),
      type: ChallengeType.sentenceOrder),
  Challenge(
      id: 1,
      lessonId: 1,
      order: 1,
      question: 'Translate the word "Hello"',
      data: TranslateChallengeData(answers: ['hello']),
      type: ChallengeType.translateWritten),
  Challenge(
      id: 3,
      lessonId: 1,
      order: 3,
      question: 'Translate the word "World"',
      data: TranslateChallengeData(answers: ['world']),
      type: ChallengeType.translateWritten),
  Challenge(
      id: 4,
      lessonId: 1,
      order: 4,
      question: 'Select the correct option - multiple choices',
      data: MultipleChoiceChallengeData(
        options: dummyChallengeOptions
            .where((option) => option.challengeId == 2)
            .toList(),
      ),
      type: ChallengeType.multipleChoice),
];

List<Lesson> dummyLessons = [
  Lesson(
    id: 1,
    unitId: 1,
    title: 'Introduction to Geography',
    order: 5,
    challenges:
        dummyChallenges.where((challenge) => challenge.lessonId == 1).toList(),
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

import 'package:language_app/data/models/unit.dart';
import 'package:language_app/data/models/lesson.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/data/models/challenge_option.dart';
import 'package:language_app/data/models/challenge_data.dart';

List<ChallengeOption> dummyChallengeOptions = [
  ChallengeOption(id: 1, challengeId: 1, correct: true, text: 'Option 1'),
  ChallengeOption(id: 2, challengeId: 1, correct: false, text: 'Option 2'),
  ChallengeOption(id: 3, challengeId: 1, correct: true, text: 'Option 1'),
  ChallengeOption(id: 4, challengeId: 1, correct: false, text: 'Option 2'),
  ChallengeOption(id: 90, challengeId: 2, correct: true, text: 'Option 3'),
  ChallengeOption(id: 100, challengeId: 2, correct: false, text: 'Option 4'),
];

List<Challenge> dummyChallenges = [
  Challenge(
      id: 1,
      lessonId: 1,
      order: 1,
      question: 'Translate the word "Hello"',
      data: TranslateChallengeData(answers: ['hello']),
      type: ChallengeType.translateWritten),
  Challenge(
      id: 2,
      lessonId: 1,
      order: 2,
      question: 'What is 2 + 2?',
      data: MultipleChoiceChallengeData(
        options: dummyChallengeOptions
            .where((option) => option.challengeId == 2)
            .toList(),
      ),
      type: ChallengeType.multipleChoice),
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
      question: 'Select the correct option',
      data: MultipleChoiceChallengeData(
        options: dummyChallengeOptions
            .where((option) => option.challengeId == 2)
            .toList(),
      ),
      type: ChallengeType.multipleChoiceWithImages),
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

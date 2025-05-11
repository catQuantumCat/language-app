import 'package:flutter_test/flutter_test.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/models/result_model.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/models/challenge_data.dart';
import 'package:language_app/domain/models/challenge_option.dart';
import 'package:language_app/domain/models/lesson.dart';

class MockLessonRemoteDatasource implements LessonRemoteDatasource {
  List<Challenge>? _challengeResponse;
  List<Unit>? _unitResponse;
  List<Lesson>? _lessonResponse;

  void setGetLessonExercisesResponse(List<Challenge> response) {
    _challengeResponse = response;
  }

  void setGetUnitsResponse(List<Unit> response) {
    _unitResponse = response;
  }

  void setGetLessonsResponse(List<Lesson> response) {
    _lessonResponse = response;
  }

  @override
  Future<List<Challenge>> getLessonExercises(String lessonId) async {
    return _challengeResponse ?? [];
  }

  @override
  Future<List<Lesson>> getLessons(String unitId) async {
    return _lessonResponse ?? [];
  }

  @override
  Future<List<Unit>> getUnits(String languageId) async {
    return _unitResponse ?? [];
  }

  @override
  Future<void> sendResult(String unitId, ResultModel result) {
    // TODO: implement sendResult
    throw UnimplementedError();
  }
}

void main() {
  late LessonRepoImp lessonRepo;
  late MockLessonRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockLessonRemoteDatasource();
    lessonRepo = LessonRepoImp(remoteDatasource: mockRemoteDatasource);
  });

  group('LessonRepoImp', () {
    group('getChallengeList', () {
      test('should return list of challenges from remote datasource', () async {
        // Arrange
        const lessonId = '123';
        final challenges = [
          Challenge(
            id: '1',
            lessonId: lessonId,
            order: 1,
            exerciseType: ExerciseType.multipleChoice,
            question: 'What is this?',
            instruction: 'Choose the correct answer',
            data: MultipleChoiceChallengeData(
              options: [
                MultipleChoiceOption(
                  id: '1',
                  exerciseId: '1',
                  text: 'correct',
                  correct: true,
                ),
                MultipleChoiceOption(
                  id: '2',
                  exerciseId: '1',
                  text: 'wrong1',
                  correct: false,
                ),
                MultipleChoiceOption(
                  id: '3',
                  exerciseId: '1',
                  text: 'wrong2',
                  correct: false,
                ),
              ],
            ),
          ),
        ];
        mockRemoteDatasource.setGetLessonExercisesResponse(challenges);

        // Act
        final result = await lessonRepo.getChallengeList(lessonId: lessonId);

        // Assert
        expect(result, equals(challenges));
      });
    });

    group('getAllUnits', () {
      test('should return list of units from remote datasource', () async {
        // Arrange
        const languageId = '123';
        final units = [
          Unit(
            id: '1',
            title: 'Unit 1',
            order: 1,
          ),
          Unit(
            id: '2',
            title: 'Unit 2',
            order: 2,
          ),
        ];
        mockRemoteDatasource.setGetUnitsResponse(units);

        // Act
        final result = await lessonRepo.getAllUnits(languageId: languageId);

        // Assert
        expect(result, equals(units));
      });
    });

    group('getLessons', () {
      test('should return list of lessons from remote datasource', () async {
        // Arrange
        const unitId = '123';
        final lessons = [
          Lesson(
            id: '1',
            title: 'Lesson 1',
            unitId: unitId,
            order: 1,
          ),
          Lesson(
            id: '2',
            title: 'Lesson 2',
            unitId: unitId,
            order: 2,
          ),
        ];
        mockRemoteDatasource.setGetLessonsResponse(lessons);

        // Act
        final result = await lessonRepo.getLessons(unitId: unitId);

        // Assert
        expect(result, equals(lessons));
      });
    });
  });
}

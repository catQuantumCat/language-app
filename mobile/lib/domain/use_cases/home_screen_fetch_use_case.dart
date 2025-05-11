import 'dart:developer';

import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';

class HomeScreenFetchUseCase {
  final LessonRepo _lessonRepo;

  HomeScreenFetchUseCase({required LessonRepo lessonRepo})
      : _lessonRepo = lessonRepo;

  Future<List<Unit>> call({required String languageId}) async {
    final List<Unit> units =
        await _lessonRepo.getAllUnits(languageId: languageId);

    // final List<Unit> unitsWithLessons = [];

    // Fetch all lessons in parallel

    //A list of futures, each future is a lesson fetch
    final futures = units.map((unit) async {
      final lessons = await _lessonRepo.getLessons(unitId: unit.id);
      return unit.copyWith(lessons: lessons);
    });

    final unitsWithLessons = await Future.wait(futures);

    // for (var unit in units) {
    //   final lessons = await _lessonRepo.getLessons(unitId: unit.id);

    //   unitsWithLessons.add(unit.copyWith(lessons: lessons));

    //   log(unit.toString());
    // }
    // log(units.toString());
    return unitsWithLessons;
  }
}

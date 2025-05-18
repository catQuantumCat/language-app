
import 'dart:convert';

import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenFetchUseCase {
  final LessonRepo _lessonRepo;
  final SharedPreferences _prefs;

  HomeScreenFetchUseCase(
      {required LessonRepo lessonRepo, required SharedPreferences prefs})
      : _lessonRepo = lessonRepo,
        _prefs = prefs;

  Future<List<Unit>> call({required String languageId}) async {
   
    // if (_isCacheValid('units_$languageId')) {
    //   final cachedData = _prefs.getString('units_$languageId');

    //   if (cachedData != null) {
    //     final returnList = <Unit>[];
    //     final Map<String, dynamic> decoded = jsonDecode(cachedData);

    //     final decodedList = decoded['data'];
    //     for (final item in decodedList) {
    //       returnList.add(Unit.fromJson(item));
    //     }
    //     await Future.delayed(Duration.zero);
    //     return Future.value(returnList);
    //   }
    // }

    // Fetch fresh data
    return await _fetchAndCacheData(languageId);
  }

  Future<List<Unit>> _fetchAndCacheData(String languageId) async {
    final units = await _lessonRepo.getAllUnits(languageId: languageId);
    final futures = units.map((unit) async {
      final lessons = await _lessonRepo.getLessons(unitId: unit.id);
      return unit.copyWith(lessons: lessons);
    });

    final unitsWithLessons = await Future.wait(futures);
    _cacheData('units_$languageId', unitsWithLessons);
    return unitsWithLessons;
  }

  void _cacheData(String key, List<Unit> data) {
    final cacheItem = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'data': data.map((unit) => unit.toJson()).toList(),
    };
    _prefs.setString(key, jsonEncode(cacheItem));
  }

  bool _isCacheValid(String key, {Duration maxAge = const Duration(hours: 1)}) {
    final cachedJson = _prefs.getString(key);
    if (cachedJson == null) return false;

    try {
      final cached = jsonDecode(cachedJson);
      final timestamp = cached['timestamp'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      return age < maxAge.inMilliseconds;
    } catch (e) {
      return false;
    }
  }
}

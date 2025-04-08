import 'dart:developer';

import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/data/models/challenge.dart';
import 'package:language_app/main.dart';

final class LessonRemoteDatasource {
  Future<List<Challenge>> getChallengeList() async {
    final response = await dio.get(Endpoints.getExercises);

    print(response.data);

    final List<Challenge> toReturn = [];

    for (final d in response.data) {
      toReturn.add(Challenge.fromJson(d));
    }

    return toReturn;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/modules/home/home_view.dart';

final dio = Dio();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = LessonRepoImp(remoteDatasource: LessonRemoteDatasource());

    ds.getChallengeList();

    return MaterialApp(
      home: HomePage(
        unit: dummyUnits[0],
      ),
    );
  }
}

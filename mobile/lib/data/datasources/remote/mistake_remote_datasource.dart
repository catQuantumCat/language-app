// data/datasources/remote/mistake_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/domain/models/mistake_entry.dart';

class MistakeRemoteDatasource {
  final Dio _dio;

  MistakeRemoteDatasource(this._dio);

  Future<List<MistakeEntry>> getUserMistakes(String userId) async {
    // Sử dụng đúng cách - không thêm dấu / thừa
    final response = await _dio.get('${Endpoints.getUserMistakes}/$userId');
    return (response.data as List<dynamic>)
        .map((e) => MistakeEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MistakeDetail> getMistakeDetail(String mistakeId) async {
    final response = await _dio.get('${Endpoints.getMistakeDetail}/$mistakeId');
    return MistakeDetail.fromJson(response.data);
  }
}

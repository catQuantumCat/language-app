// services/upload_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';

class UploadService {
  final Dio _dio;
  
  UploadService(this._dio);
  
  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      
      final response = await _dio.post(
        '${Endpoints.baseApi}upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return response.data['url'];
      }
      return null;
    } catch (e) {
      
      return null;
    }
  }
}

import 'package:dio/dio.dart';
import '../config/app_config.dart';

class DataService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: AppConfig.instance.supabaseUrl),
  );

  Future<Response<dynamic>> fetch(String endpoint) {
    return _dio.get(endpoint);
  }
}

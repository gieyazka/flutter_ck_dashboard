import 'package:ck_dashboard/core/variable.dart';
import 'package:dio/dio.dart';
import "./logger.dart";

class ApiService {
  final Dio _dio;
  static final String baseUrl = NEXT_SERVER;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // onRequest: (options, handler) {
        //   logger.i('→ REQUEST [${options.method}] ${options.uri}');
        //   logger.t('Headers: ${options.headers}');
        //   logger.t('Body   : ${options.data}');
        //   handler.next(options);
        // },
        onResponse: (response, handler) {
          logger.i(
            '← RESPONSE [${response.statusCode}] ${response.requestOptions.uri}',
          );
          logger.t('Response: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          logger.e(
            '✕ ERROR [${error.response?.statusCode}] ${error.requestOptions.uri}',
          );
          logger.e('Error   : ${error.error}');
          if (error.response?.data != null) {
            logger.d('Payload : ${error.response!.data}');
          }
          handler.next(error);
        },
      ),
    );
  }

  // ตัวอย่างเมธอด GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.get(path, queryParameters: query, options: options);
  }

  // ตัวอย่างเมธอด POST
  Future<Response> post(String path, {dynamic data, Options? options}) {
    return _dio.post(path, data: data, options: options);
  }
}

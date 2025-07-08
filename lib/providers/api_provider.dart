import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/dio.dart';

/// ให้สร้าง ApiService พร้อม baseUrl จาก .env
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

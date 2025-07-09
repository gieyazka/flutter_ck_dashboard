import 'package:ck_dashboard/core/dio.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/core/util.dart';
import 'package:ck_dashboard/models/appwrite_model.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:dio/dio.dart';
import 'package:ck_dashboard/core/variable.dart';

Future getNextLotteryDate() async {
  final api = ApiService();
  final jwt = generateJwt({'iss': JWT_ISSUER});

  final resp = await api.get(
    '/api/lotteryDate',
    options: Options(headers: {'Authorization': 'Bearer $jwt'}),
  );
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch user: ${resp.data['message']}');
  }

  final data = resp.data as Map<String, dynamic>;
  if (data.isEmpty) {
    throw Exception('User not found');
  }
  return LotteryDateAppwrite.fromJson(data);
}

Future getDigitSummary({
  required String date,
  required int type,
  required String lotteryDateId,
}) async {
  final api = ApiService();
  final jwt = generateJwt({'iss': JWT_ISSUER});

  final resp = await api.post(
    '/api/dashboard',
    data: {'formatDate': date, 'type': type, 'lotteryDateId': lotteryDateId},
    options: Options(headers: {'Authorization': 'Bearer $jwt'}),
  );
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch user: ${resp.data['message']}');
  }
  // logger.i('get digit summary fetched successfully ${resp.data}');

  final data = resp.data as Map<String, dynamic>;
  if (data.isEmpty) {
    throw Exception('User not found');
  }
  return DigitSummary.fromJson(data);
}

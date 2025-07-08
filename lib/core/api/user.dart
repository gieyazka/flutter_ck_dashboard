import "package:appwrite/appwrite.dart";
import "package:appwrite/models.dart";
import "package:ck_dashboard/core/appwrite_service.dart";
import "package:ck_dashboard/models/appwrite_model.dart";
import "package:dio/dio.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "../logger.dart";
import "../dio.dart";
import "../util.dart";

class LoginResponse {
  final bool success;
  final Session? session;
  final String? message;

  LoginResponse({required this.success, this.session, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json['success'] as bool,
    session: json['session'] != null ? Session.fromMap(json['session']) : null,
    message: json['message'] as String?,
  );
}


  class AccountResponse {
  final bool success;
  final User? user;
  final String? message;

  AccountResponse({required this.success, this.user, this.message});

  factory AccountResponse.fromJson(Map<String, dynamic> json) => AccountResponse(
    success: json['success'] as bool,
    user: json['user'] != null ? User.fromMap(json['user']) : null,
    message: json['message'] as String?,
  );
}


Future getUserByUsername({required String username}) async {
  final api = ApiService();
  final jwt = generateJwt({
    'username': username,
    'iss': dotenv.env['JWT_ISSUER'],
  });

  final resp = await api.post(
    '/api/user/get-username',
    data: {'username': username},
    options: Options(headers: {'Authorization': 'Bearer $jwt'}),
  );
  if (resp.statusCode != 200) {
    throw Exception('Failed to fetch user: ${resp.data['message']}');
  }
  final userData = resp.data['data'] as Map<String, dynamic>;
  if (userData.isEmpty) {
    throw Exception('User not found');
  }
  return UsernameAppwrite.fromJson(userData);
}

Future<LoginResponse> createSession({
  required String email,
  required String password,
}) async {
  try {
    final appwrite = await AppwriteService();
    final res = await appwrite.account.createEmailPasswordSession(
      email: email,
      password: password,
    );
    return LoginResponse(
      success: true,
      session: res,
      message: 'Login successful',
    );
  } on AppwriteException catch (e) {
    // จัดการ error (เช่น รหัสผ่านผิด, user ไม่พบ ฯลฯ)
    logger.e('Error creating session: ${e.message}');
    throw Exception('Login failed: ${e.message}');
  }
}
Future<AccountResponse> getSession() async {
  try {
    final appwrite = await AppwriteService();
    final session = await appwrite.account.getSession(sessionId: "current");
    if (session == null) {
      return AccountResponse(
        success: false,
        user: null,
        message: 'No active session found',
      );
    }
    final user = await appwrite.account.get();
    return AccountResponse(
      success: true,
      user: User.fromMap(user.toMap()),
      message: 'User fetched successfully',
    );
  } on AppwriteException catch (e) {
    // จัดการ error (เช่น รหัสผ่านผิด, user ไม่พบ ฯลฯ)
    logger.e('Error creating session: ${e.message}');
    throw Exception('Login failed: ${e.message}');
  }
}



Future deleteSession() async {
  final service = AppwriteService();
  try {
    await service.account.deleteSession(sessionId: "current");
    return {'success': true, 'message': 'Session deleted successfully'};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}
Future<bool> isUserLoggedIn() async {
  final service = AppwriteService();
  try {
    final session = await service.account.getSession(sessionId: "current");
    return session != null;
  } catch (e) {
    logger.e('Error checking user login status: $e');
    return false;
  }
}
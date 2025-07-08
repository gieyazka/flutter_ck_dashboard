import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

/// Generate a JWT token with a given secret and payload
String generateJwt(Map<String, dynamic> payload) {
  final jwt = JWT(payload, issuer: 'ck_dashboard');

  // Sign the JWT with the secret
  final token = jwt.sign(
    SecretKey(dotenv.env['JWT_SECRET']!),
    algorithm: JWTAlgorithm.HS384,
  );

  return token;
}

String formatYMD(DateTime dt) {
  final localDt = dt.toLocal();
  final ymd = DateFormat('yyyyMMdd').format(localDt);
  return ymd;
}

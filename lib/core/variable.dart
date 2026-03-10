import 'package:flutter_dotenv/flutter_dotenv.dart';

String get JWT_ISSUER => dotenv.get('JWT_ISSUER');
String get JWT_SECRET => dotenv.get('JWT_SECRET');
String get APPWRITE_ENDPOINT => dotenv.get('APPWRITE_ENDPOINT');
String get APPWRITE_PROJECT => dotenv.get('APPWRITE_PROJECT');
String get NEXT_SERVER => dotenv.get('NEXT_SERVER');
String get WEBSOCKET_URL => dotenv.get('WEBSOCKET_URL');

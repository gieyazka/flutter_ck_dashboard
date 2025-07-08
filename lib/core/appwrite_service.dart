import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteService {
  // 1. กำหนด client
  final Client client = Client()
      .setEndpoint(
        dotenv.env['APPWRITE_ENDPOINT']!,
      ) // เช่น https://cloud.appwrite.io/v1
      .setProject(dotenv.env['APPWRITE_PROJECT']!);

  late final Account account;
  late final Databases database;
  AppwriteService() {
    account = Account(client);
    database = Databases(client);
  }
}

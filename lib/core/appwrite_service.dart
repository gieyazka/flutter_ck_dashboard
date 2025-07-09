import 'package:appwrite/appwrite.dart';
import 'package:ck_dashboard/core/variable.dart';

class AppwriteService {
  // 1. กำหนด client
  final Client client = Client()
      .setEndpoint(APPWRITE_ENDPOINT) // เช่น https://cloud.appwrite.io/v1
      .setProject(APPWRITE_PROJECT);
  // dotenv.env['APPWRITE_ENDPOINT']!,
  late final Account account;
  late final Databases database;
  AppwriteService() {
    account = Account(client);
    database = Databases(client);
  }
}

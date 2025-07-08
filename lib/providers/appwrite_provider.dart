import 'package:ck_dashboard/core/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

final appwriteClientProvider = Provider<Client>((ref) {
  final client = AppwriteService().client;
  return client;
});
final databasesProvider = Provider<Databases>((ref) {
  final client = ref.read(appwriteClientProvider);
  return Databases(client);
});


final accountProvider = Provider<Account>((ref) {
  final client = ref.read(appwriteClientProvider);
  return Account(client);
});


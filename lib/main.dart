import 'dart:io';

import 'package:ck_dashboard/core/variable.dart';

import 'platform/platform.dart';
import 'package:ck_dashboard/core/api/user.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/core/router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
part 'main.g.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
@riverpod
String helloWorld(Ref ref) {
  return 'Hello world';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // try {
  //   final result = await InternetAddress.lookup(Uri.parse(NEXT_SERVER).host);
  //   print('✅ DNS resolved: ${result.first.address}');
  // } catch (e) {
  //   print('❌ DNS lookup failed: $e');
  // }
  // try {
  //   final isOnline = await InternetAddress.lookup('google.com');
  //   print('🌐 Online: ${isOnline.isNotEmpty}');
  // } catch (e) {
  //   print(e);
  // }
  // print("🧪 JWT_ISSUER = $JWT_ISSUER");
  // print("🧪 JWT_SECRET = $JWT_SECRET");
  // print("🧪 APPWRITE_ENDPOINT = $APPWRITE_ENDPOINT");
  // print("🧪 APPWRITE_PROJECT = $APPWRITE_PROJECT");
  // print("🧪 NEXT_SERVER = $NEXT_SERVER");
  // print("🧪 WEBSOCKET_URL = $WEBSOCKET_URL");

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    logger.e('.env failed to load  $e');
  }

  try {
    await deleteSession();
  } catch (e) {
    logger.e('Error deleting session: $e');
  }

  runApp(ProviderScope(child: MyApp()));
}

// Extend HookConsumerWidget instead of HookWidget, which is exposed by Riverpod
class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can use hooks inside HookConsumerWidget

    final String value = ref.watch(helloWorldProvider);

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(1)),
          child: child!,
        );
      },
    );
  }
}

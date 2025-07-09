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

  // โหลดแบบชี้ path เต็มไปเลย
  // try {
  //   await dotenv.load();
  // } catch (e) {
  //   logger.e('.env failed to load  $e');
  // }

  try {
    await deleteSession();
  } catch (e) {
    logger.e('Error deleting session: $e');
  }
  // สำหรับแพลตฟอร์ม desktop เท่านั้น

  if (!kIsWeb && PlatformWrapper.isWindows ||
      PlatformWrapper.isLinux ||
      PlatformWrapper.isMacOS) {
    // ตั้งขนาดหน้าต่างเริ่มต้น
    await DesktopWindow.setWindowSize(const Size(1280, 720));

    // ล็อกขนาดขั้นต่ำ = ขนาดสูงสุด = 1280×720
    await DesktopWindow.setMinWindowSize(const Size(1280, 720));
    await DesktopWindow.setMaxWindowSize(const Size(1280, 720));

    // (ตัวเลือก) ตั้ง title ของหน้าต่าง (Windows เท่านั้น)
    // DesktopWindow.setWindowTitle('CK Group Dashboard');
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

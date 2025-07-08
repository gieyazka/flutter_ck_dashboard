// providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ck_dashboard/core/websocket.dart';

// 1) Provider สำหรับสร้าง service (singleton)
final wsServiceProvider = Provider<WebSocketService>((ref) {
  final svc = WebSocketService(reconnectDelay: const Duration(seconds: 2));
  ref.onDispose(svc.close);
  return svc;
});

// 2) StreamProvider เพื่อให้ UI subscribe ข้อความเข้า
final wsDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final svc = ref.watch(wsServiceProvider);
  return svc.stream;
});

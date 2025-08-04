// websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:ck_dashboard/core/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:ck_dashboard/core/variable.dart';
import 'package:stream_transform/stream_transform.dart';

class WebSocketService {
  final Duration reconnectDelay;
  late WebSocketChannel _channel;
  Map<String, dynamic>? _lastSent;
  Timer? _pingTimer;
  final _inController = StreamController<Map<String, dynamic>>.broadcast();
  bool _closed = false;
  final Uri uri = Uri.parse(
    WEBSOCKET_URL ?? 'wss://admin.mylaos.life/api/calculation/realtime',
  );

  WebSocketService({this.reconnectDelay = const Duration(seconds: 2)}) {
    _connectLoop();
  }
  Stream<Map<String, dynamic>> get stream => _inController.stream
      .debounce(const Duration(milliseconds: 200))
      // ถ้าต้องการให้เป็น broadcast อีกครั้ง (หากมีหลาย listener)
      .asBroadcastStream();


  void send(Map<String, dynamic> msg, bool keep) {
    if (_closed) return;

    if (keep) {
      _lastSent = msg;
    }
    _channel.sink.add(jsonEncode(msg));
  }

  Future<void> close() async {
    _closed = true;
    _pingTimer?.cancel();
    await _channel.sink.close(status.normalClosure);
    await _inController.close();
  }

  void _connectLoop() async {
    while (!_closed) {
      try {
        _channel = WebSocketChannel.connect(uri);
        logger.i('✅ WebSocket connected to $uri');

        _pingTimer = Timer.periodic(Duration(seconds: 30), (_) {
          if (!_closed) {
            // logger.d('Sending ping to WebSocket');
            _channel.sink.add(jsonEncode({'action': 'ping'}));
          }
        });
        if (_lastSent != null) {
          _channel.sink.add(jsonEncode(_lastSent));
        }
        await for (final raw in _channel.stream) {
          final data = jsonDecode(raw as String) as Map<String, dynamic>;
          _inController.add(data);
        }

        _pingTimer?.cancel();
        logger.w('WebSocket closed by server');
      } catch (e, st) {
        logger.e('WebSocket error:', error: e, stackTrace: st);
      }
      if (!_closed) {
        logger.i('Reconnecting in $reconnectDelay...');
        await Future.delayed(reconnectDelay);
      }
    }
  }
}

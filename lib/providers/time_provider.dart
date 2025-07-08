import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(Duration(seconds: 1), (_) => DateTime.now());
});
final expiryProvider = FutureProvider<DateTime?>((ref) async {
  final state = ref.watch(lotteryDateProvider);
  return state.lotteryDate?.endTime;
});
final countdownProvider = StreamProvider<Duration?>((ref) {
  // ดึง endTime มาเป็น DateTime?
  final expiry = ref.watch(
    lotteryDateProvider.select((s) => s.lotteryDate?.endTime),
  );
  // generator ส่งค่าทีละช่วง
  return (() async* {
    // ถ้าไม่มี expiry เลย ส่ง null แล้วจบเลย
    if (expiry == null) {
      yield null;
      return;
    }

    while (true) {
      final now = DateTime.now();
      // ถ้าเลยเวลาแล้ว ส่ง null แล้วหยุดสตรีม
      if (now.isAfter(expiry)) {
        ref.refresh(lotteryDateProvider);

        yield null;

        return;
      }

      // คำนวณ Diff แล้วแปลงเป็น DateTime (ฐาน 1970)
      final remaining = expiry.difference(now);
      yield remaining;

      await Future.delayed(const Duration(seconds: 1));
    }
  })();
});

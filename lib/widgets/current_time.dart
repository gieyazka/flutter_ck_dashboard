import 'package:ck_dashboard/providers/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// DigitalClock widget เป็น ConsumerWidget
class DigitalClock extends ConsumerWidget {
  const DigitalClock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch provider
    final asyncTime = ref.watch(timeProvider);

    return asyncTime.when(
      data: (now) {
        // format เวลาและวัน
        final timeString = DateFormat('HH : mm').format(now);
        final dateString = DateFormat('dd-MM-yyyy').format(now);

        return IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/clock_color.png',
                  width: 44,
                  height: 44,
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // แสดงเวลา
                    Text(
                      timeString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // แสดงวันที่
                    Text(
                      dateString,
                      style: TextStyle(color: Colors.white70, fontSize: 24),
                    ),
                    // SizedBox(height: 6),
                    // เส้นสีน้ำเงินด้านล่าง
                    // Container(
                    //   height: 2,
                    //   width: double.infinity,
                    //   color: Colors.blueAccent,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
      error: (err, _) => Text('Error: $err'),
    );
  }
}

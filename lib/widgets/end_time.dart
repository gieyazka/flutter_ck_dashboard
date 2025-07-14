import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/providers/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// EndTimeClock widget เป็น ConsumerWidget
class EndTimeClock extends ConsumerWidget {
  const EndTimeClock({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/hourglass_color.png',
                  width: 44,
                  height: 44,

                ),
                SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // แสดงเวลา
                    ref
                        .watch(countdownProvider)
                        .when(
                          data: (duration) {
                            if (duration == null) {
                              return Text('No duration');
                            }
                            final days = duration.inDays;
                            // รอเวลาเหลือหลังหักวันเต็มออก
                            final hours = duration.inHours
                                .remainder(24)
                                .toString()
                                .padLeft(2, '0');
                            final minutes = duration.inMinutes
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                            final seconds = duration.inSeconds
                                .remainder(60)
                                .toString()
                                .padLeft(2, '0');
                
                            String text;
                            if (days > 0) {
                              final dayLabel = days > 1 ? 'days' : 'day';
                              text = '$days $dayLabel $hours:$minutes:$seconds';
                            } else {
                              text = '$hours : $minutes : $seconds';
                            }
                
                            return Text(
                              text,
                              style: TextStyle(fontSize: 32, color: Colors.white),
                            );
                          },
                          loading: () => Text('Loading...'),
                          error: (e, _) => Text('Error'),
                        ),
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

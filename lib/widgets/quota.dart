import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullQuota extends ConsumerWidget {
  final String title;
  final List<Accumulate> accumulate;
  const FullQuota({Key? key, required this.title, required this.accumulate})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch ค่าจำนวนลูกค้า

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFF292D36),
              child: Column(
                children: [
                  const SizedBox(height: 8), // เว้นระยะห่างด้านบน

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFD8B0B),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // เว้นระยะห่างด้านบน
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final n in accumulate)
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        n.lottery.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      // padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Color(0xFF292D36),
                        border: Border.all(color: Colors.red, width: 2),
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

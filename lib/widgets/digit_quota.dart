import 'dart:math';

import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/providers/digit_summary_provider.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// จำนวนเป้าหมาย

class DigitQuota extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch ค่าจำนวนลูกค้า
    final lotteryDate = ref.watch(lotteryDateProvider);
    final dashboardSummary = ref.watch(DigitSummaryProvider);
    final digit = dashboardSummary.digit;
    final current = dashboardSummary.digitSummary?.dashboardSummary.quota ?? 0;
    final divisor = pow(10, digit ?? 0);
    // final target =
    //     ((dashboardSummary.digitSummary?.digitQuota.amount ?? 0) / divisor)
    //         .toInt();
    final target = (dashboardSummary.digitSummary?.digitQuota.amount ?? 0)
        .toInt();
    String _formatNumber(int value) {
      return NumberFormat.decimalPattern().format(value);
    }

    // ป้องกันหารด้วยศูนย์
    final ratio = target > 0 ? (current.clamp(0, target) / target) : 0.0;

    Color barColor;
    if (ratio > 0.8) {
      barColor = Colors.teal;
    } else if (ratio > 0.5) {
      barColor = Colors.yellow;
    } else {
      barColor = Colors.red;
    }

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
                    'จำนวนโควต้า เลข ${digit ?? 0} หลัก',
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1) Progress bar
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final fullWidth = constraints.maxWidth;
                      final fillWidth = fullWidth * ratio;
                      return Stack(
                        children: [
                          // background
                          Container(
                            width: fullWidth,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              // borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // filled bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: fillWidth,
                            height: 44,
                            decoration: BoxDecoration(
                              color: barColor,
                              // borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // 2) Text label
                  Text(
                    '${_formatNumber(current)} / ${_formatNumber(target)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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

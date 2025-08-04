import 'dart:math';

import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/SummaryDashboard_model.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/digit_summary_provider.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AllQuota extends ConsumerWidget {
  final String title;
  final List<SummaryData> dashboardSummary;
  const AllQuota({
    Key? key,
    required this.title,
    required this.dashboardSummary,
  }) : super(key: key);
  String _fmt(int n) => NumberFormat.decimalPattern().format(n);
  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.fromLTRB(16, 4, 4, 16),
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

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: this.dashboardSummary.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, i) {
                  final item = this.dashboardSummary[i];

                  final ratio = item.revenue > 0
                      ? (item.revenue / item.maxQuota).clamp(0.0, 1.0)
                      : 0.0;
                  Color barColor;
                  if (ratio > 0.8) {
                    barColor = Colors.green;
                  } else if (ratio > 0.5) {
                    barColor = Colors.orange;
                  } else {
                    barColor = Colors.red;
                  }

                  Color fontColor;
                  if (ratio > 0.8) {
                    fontColor = Colors.white;
                  } else if (ratio > 0.5) {
                    fontColor = Colors.white;
                  } else {
                    fontColor = Colors.white;
                  }

                  return Row(
                    children: [
                      // หมายเลขด้านซ้าย
                      SizedBox(
                        width: 80,
                        child: Text(
                          softWrap: false,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          item.type.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // แถบ progress + label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // bar
                            LayoutBuilder(
                              builder: (ctx, c) {
                                final fullW = c.maxWidth;
                                return Stack(
                                  // alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: fullW,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: fullW * ratio,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: barColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),

                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          // '${_fmt(item.quota.toInt())} / ${_fmt(item.maxQuota.toInt())}',
                                          '${_fmt(item.revenue.toInt())} / ${_fmt(item.maxQuota.toInt())}',
                                          style: TextStyle(
                                            color: fontColor,
                                            fontSize: 44,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            // ข้อความตัวเลข
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

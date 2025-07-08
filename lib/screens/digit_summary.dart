// lib/screens/dashboard_screen.dart
import 'dart:convert';

import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/digit_summary_provider.dart';
import 'package:ck_dashboard/providers/web_socker_provider.dart';
import 'package:ck_dashboard/widgets/count_customer.dart';
import 'package:ck_dashboard/widgets/current_time.dart';
import 'package:ck_dashboard/widgets/digit_quota.dart' as widget;
import 'package:ck_dashboard/widgets/end_time.dart';
import 'package:ck_dashboard/widgets/quota.dart';
import 'package:ck_dashboard/widgets/top_accumulate.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final digitOptions = [2, 3, 4, 5, 6];

class SummaryDigitScreen extends ConsumerWidget {
  const SummaryDigitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digitProvider = ref.watch(DigitSummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0x1C1C1C),
      body: SafeArea(
        child: Column(
          children: [
            // 1) Header (เวลา + โลโก้)
            Container(
              color: const Color(0xFF292D36),
              child: Column(
                children: [
                  // const SizedBox(height: 24), // เว้นระยะห่างด้านบน
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DigitalClock(),
                        // const Spacer(),
                        // แทนโลโก้
                        Image.asset(
                          'assets/logo.png',
                          width: 240,
                          fit: BoxFit
                              .fitHeight, // BoxFit.cover / fill / fitWidth ได้ตามต้องการ
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            EndTimeClock(),
                            // const SizedBox(height: 8),
                            SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<int>(
                                value: digitProvider.digit,
                                hint: Text(
                                  'Select a digit',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors.black,
                                iconEnabledColor: Colors.white,
                                // isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: digitOptions.map((digit) {
                                  return DropdownMenuItem(
                                    value: digit,
                                    child: Text(digit.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  ref
                                      .read(DigitSummaryProvider.notifier)
                                      .setDigit(newValue!);
                                },
                                validator: (v) =>
                                    v == null ? 'Please select one' : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2) เนื้อหา 4 คอลัมน์
            Expanded(
              child: StaggeredGrid.count(
                // จำนวนคอลัมน์ต่อแถว
                crossAxisCount: 11,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 1.3, //height ratio
                    child: CustomerCountCard(),
                  ),

                  StaggeredGridTile.count(
                    crossAxisCellCount: 5,
                    mainAxisCellCount: 1.3,
                    child: widget.DigitQuota(),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 2.55,
                    child: FullQuota(
                      title: 'ตัวเลขที่เต็มโควต้า',
                      accumulate: digitProvider.digitSummary?.fullQuota ?? [],
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 3.8, //height ratio
                    child: TopAccumulate(
                      title: '10 ตัวที่ขายมากที่สุด',
                      accumulate:
                          digitProvider.digitSummary?.topAccumulate ?? [],
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 3.8, //height ratio
                    child: TopAccumulate(
                      title: '10 ตัวที่ขายน้อยที่สุด',
                      accumulate:
                          digitProvider.digitSummary?.bottomAccumulate ?? [],
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 2.55,
                    child: FullQuota(
                      title: 'ตัวเลขที่ไม่ขาย',
                      accumulate:
                          digitProvider.digitSummary?.notBuyAccumulate ?? [],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )..listenToWebSocket(ref);
    ;
  }
}

extension _WebSocketListener on Widget {
  Widget listenToWebSocket(WidgetRef ref) {
    ref.listen<AsyncValue<Map<String, dynamic>>>(wsDataProvider, (prev, next) {
      next.whenData((msg) {
        final payload = msg['value'];
        if (payload != null) {
          // เลื่อนอัปเดต state ไปหลัง build จบ
          Future.microtask(() {
            ref
                .read(DigitSummaryProvider.notifier)
                .handleSocketData(payload as Map<String, dynamic>);
          });
        }
      });
    });
    return this;
  }
}

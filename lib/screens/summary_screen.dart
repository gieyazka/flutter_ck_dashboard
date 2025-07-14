// lib/screens/dashboard_screen.dart
import 'dart:convert';

import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/digit_summary_provider.dart';
import 'package:ck_dashboard/providers/summary_provider.dart';
import 'package:ck_dashboard/providers/web_socker_provider.dart';
import 'package:ck_dashboard/widgets/all_quota.dart';
import 'package:ck_dashboard/widgets/count_customer.dart';
import 'package:ck_dashboard/widgets/current_time.dart';
import 'package:ck_dashboard/widgets/digit_quota.dart' as widget;
import 'package:ck_dashboard/widgets/end_time.dart';
import 'package:ck_dashboard/widgets/quota.dart';
import 'package:ck_dashboard/widgets/top_accumulate.dart';
import 'package:ck_dashboard/widgets/total_buy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final digitOptions = [2, 3, 4, 5, 6];

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainDashboardProvider = ref.watch(SummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
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
                crossAxisCount: 10,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1.3, //height ratio
                    child: CustomerCountCard(),
                  ),

                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 1.3,
                    child: TotalBuy()
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 2.65,
                    child: FullQuota(
                      title: 'ตัวเลขที่เต็มโควต้า',
                      accumulate: [],
                    ),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 5,
                    mainAxisCellCount: 4, //height ratio
                    child: AllQuota(
                      title: 'ເລກໂຄຕ້າ',
                      dashboardSummary:
                          mainDashboardProvider
                              .summaryDashboard
                              ?.dashboardSummary ??
                          [],
                    ),
                  ),

                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 2.65,
                    child: FullQuota(title: 'ตัวเลขที่ไม่ขาย', accumulate: []),
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
          Future.microtask(() {
            ref
                .read(SummaryProvider.notifier)
                .handleSocketData(payload as Map<String, dynamic>);
          });
        }
      });
    });
    return this;
  }
}

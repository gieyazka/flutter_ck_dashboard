import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerCountCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch ค่าจำนวนลูกค้า
    final lotteryDate = ref.watch(lotteryDateProvider);
    final userCount = lotteryDate.lotteryDate?.userCount ?? 0;
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
                    'ຈໍານວນລູກຄ້າທີ່ຊື້',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ไอคอนลูกค้า
                  const SizedBox(width: 120),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person, size: 44, color: Colors.white),
                  ),

                  Expanded(
                    child: Text(
                      // ฟอร์แมตตัวเลขให้มี comma
                      userCount.toString().replaceAllMapped(
                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                        (match) => ',',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
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

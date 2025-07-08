// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            // 1) Header (เวลา + โลโก้)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text(
                    '15:37',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const Spacer(),
                  // แทนโลโก้
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'CK GROUP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2) เนื้อหา 3 คอลัมน์
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── คอลัมน์ซ้าย ───
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildCard(
                            title: 'จำนวนลูกค้าที่ซื้อ',
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '99,999',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildListCard(
                            title: '20 ตัวเลขขายมากที่สุด',
                            items: List.generate(20, (i) {
                              final number = (i * 3 + 1).toString().padLeft(
                                2,
                                '0',
                              );
                              final value = (20 - i) * 10000;
                              return _ListItem(number, value, 8000000);
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ─── คอลัมน์กลาง ───
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildProgressCard(
                            title: 'จำนวนโควต้า เลข 2 หลัก',
                            current: 300000000,
                            total: 800000000,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildListCard(
                                    title: '20 ตัวเลขขายน้อยที่สุด',
                                    items: List.generate(20, (i) {
                                      final num = i.toString().padLeft(2, '0');
                                      final val = (i + 1) * 100000;
                                      return _ListItem(num, val, 800000);
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildListCard(
                                    title: '20 ตัวเลขขายปานกลาง',
                                    items: List.generate(20, (i) {
                                      final num = (i + 21).toString().padLeft(
                                        2,
                                        '0',
                                      );
                                      final val = (i + 5) * 100000;
                                      return _ListItem(num, val, 800000);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // ─── คอลัมน์ขวา ───
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildWrapCard(
                            title: 'ตัวเลขเต็มโควต้า',
                            numbers: ['10', '19', '20', '42', '59', '98'],
                          ),
                          const SizedBox(height: 16),
                          _buildWrapCard(
                            title: 'ตัวเลขไม่ถึงโควต้า',
                            numbers: ['41', '45', '78'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required int current,
    required int total,
  }) {
    final pct = total > 0 ? current / total : 0.0;
    return _buildCard(
      title: title,
      child: Column(
        children: [
          LinearProgressIndicator(
            value: pct,
            minHeight: 24,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
          ),
          const SizedBox(height: 8),
          Text(
            '${current.toString()} / ${total.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard({
    required String title,
    required List<_ListItem> items,
  }) {
    return Expanded(
      child: _buildCard(
        title: title,
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
          itemBuilder: (context, i) {
            final it = items[i];
            final pct = it.total > 0 ? it.value / it.total : 0.0;
            final barColor = pct > 0.5
                ? Colors.green
                : pct > 0.2
                ? Colors.orange
                : Colors.red;
            return Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    it.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(height: 16, color: Colors.white24),
                      FractionallySizedBox(
                        widthFactor: pct.clamp(0.0, 1.0),
                        child: Container(height: 16, color: barColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${it.value}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWrapCard({
    required String title,
    required List<String> numbers,
  }) {
    return _buildCard(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: numbers.map((n) {
          return Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.grey[850],
              child: Text(n, style: const TextStyle(color: Colors.red)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// helper data class
class _ListItem {
  final String number;
  final int value;
  final int total;
  _ListItem(this.number, this.value, this.total);
}

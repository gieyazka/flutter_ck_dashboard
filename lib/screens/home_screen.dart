import 'package:ck_dashboard/core/api/user.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



// Menu item model
class MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });
}

// Menu items provider
final menuItemsProvider = Provider<List<MenuItem>>(
  (ref) => [
    MenuItem(
      title: 'Summary',
      subtitle: 'Summary of your data',
      icon: Icons.dashboard,
      route: '/summary',
      color: Colors.blue,
    ),
    MenuItem(
      title: 'Digit Summary',
      subtitle: 'Digit summary of your data',
      icon: Icons.shopping_cart,
      route: '/digit',
      color: Colors.green,
    ),
  ],
);

// Home Page Widget
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuItemsProvider);
    final auth = ref.watch(authProvider);

    final userData = auth.user?.name ?? 'User Name';
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: const Text(
      //     'หน้าหลัก',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   backgroundColor: Colors.blue[600],
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search, color: Colors.white),
      //       onPressed: () {
      //         // Search functionality
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.more_vert, color: Colors.white),
      //       onPressed: () {
      //         // More options
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          // 1) Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Text(
              'Hello, $userData',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2) ชื่อส่วน Main menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Main menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // 3) GridView ขยายเต็มพื้นที่แนวตั้งที่เหลือ
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuCard(context, menuItems[index]);
                },
              ),
            ),
          ),

          const SizedBox(height: 20), // ถ้าต้องการเว้นขอบล่างจริงๆ
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 30),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuItem item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          context.go(item.route);
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(item.icon, size: 30, color: item.color),
              ),
              const SizedBox(height: 20),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                item.subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

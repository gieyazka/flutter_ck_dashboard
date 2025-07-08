import 'package:ck_dashboard/screens/digit_summary.dart';
import 'package:ck_dashboard/screens/home_screen.dart';
import 'package:ck_dashboard/screens/login_screen.dart';
import 'package:ck_dashboard/screens/summary_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/summary', builder: (context, state) => const SummaryScreen()),
    GoRoute(path: '/digit', builder: (context, state) => const SummaryDigitScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
  ],
);

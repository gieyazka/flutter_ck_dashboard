import 'package:ck_dashboard/screens/digit_summary.dart';
import 'package:ck_dashboard/screens/home_screen.dart';
import 'package:ck_dashboard/screens/login_screen.dart';
import 'package:ck_dashboard/screens/summary_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/summary',
      builder: (context, state) => const SummaryScreen(),
    ),
    GoRoute(
      path: '/digit_2',
      builder: (context, state) => const SummaryDigitScreen(digit: 2),
    ),
    GoRoute(
      path: '/digit_3',
      builder: (context, state) => const SummaryDigitScreen(digit: 3),
    ),
    GoRoute(
      path: '/digit_4',
      builder: (context, state) => const SummaryDigitScreen(digit: 4),
    ),
    GoRoute(
      path: '/digit_5',
      builder: (context, state) => const SummaryDigitScreen(digit: 5),
    ),
    GoRoute(
      path: '/digit_6',
      builder: (context, state) => const SummaryDigitScreen(digit: 6),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
  ],
);

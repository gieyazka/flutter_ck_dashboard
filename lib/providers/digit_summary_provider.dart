import 'package:appwrite/models.dart';
import 'package:ck_dashboard/core/api/lottery_date.dart';
import 'package:ck_dashboard/core/appwrite_service.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/core/util.dart';
import 'package:ck_dashboard/models/appwrite_model.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:ck_dashboard/providers/web_socker_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

/// 1) สร้าง state model เพื่อเก็บ loading / user / error
class digitSummaryState {
  final bool isLoading;
  final String? error;
  final int? digit;
  final DigitSummary? digitSummary;
  const digitSummaryState({
    this.isLoading = false,
    this.error,
    this.digit, // Default digit value
    this.digitSummary,
  });

  digitSummaryState copyWith({
    bool? isLoading,
    String? error,
    int? digit,
    DigitSummary? digitSummary,
  }) {
    return digitSummaryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      digit: digit ?? this.digit,
      digitSummary: digitSummary ?? this.digitSummary,
    );
  }
}

class digitSummaryNotifier extends StateNotifier<digitSummaryState> {
  late final Ref _ref;
  digitSummaryNotifier(ref) : super(digitSummaryState()) {
    _ref = ref;
  }

  void setDigit(int newDigit) async {
    state = state.copyWith(digit: newDigit, isLoading: true, error: null);
    final lotteryDate = _ref.read(lotteryDateProvider).lotteryDate;
    final data = await getDigitSummary(
      date: formatYMD(lotteryDate!.dateTime),
      type: state.digit!,
      lotteryDateId: lotteryDate!.id,
    );
    state = state.copyWith(isLoading: false, error: null, digitSummary: data);
    // TODO: Connect Sockets
    final wsService = _ref.read(wsServiceProvider);
    wsService.send({'room': 'digit_$newDigit'}, true);
  }

  void handleSocketData(Map<String, dynamic> data) {
    final oldQuota = state.digitSummary?.digitQuota;
    final topAcc = data['topAccumulate'] as List<dynamic>?;
    final bottomAcc = data['bottomAccumulate'] as List<dynamic>?;
    final notBuyAcc = data['notBuyAccumulate'] as List<dynamic>?;
    final fullQuta = data['notSellAccumulate'] as List<dynamic>?;
    // final userCount = data["userCount"];
    final dashboardSummary = data['dashboardSummary'] as Map<String, dynamic>?;

    _ref
        .read(lotteryDateProvider.notifier)
        .setLotteryDate(LotteryDateAppwrite.fromJson(data["userCount"]));

    state = state.copyWith(
      digitSummary: DigitSummary(
        digitQuota: oldQuota!,
        topAccumulate:
            topAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
        bottomAccumulate:
            bottomAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
        notBuyAccumulate:
            notBuyAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
        fullQuota:
            fullQuta?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
        dashboardSummary: dashboardSummary != null
            ? DashboardSummary.fromJson(dashboardSummary)
            : DashboardSummary(
                id: '',
                lotteryDateId: '',
                revenue: 0,
                type: 0,
                bankWinCost: 0,
                lotteryTsCost: 0,
                pointCost: 0,
                quota: 0,
              ),
      ),
    );

    // แล้วอัปเดต state
  }
}

/// 3) ประกาศ provider
final DigitSummaryProvider =
    StateNotifierProvider<digitSummaryNotifier, digitSummaryState>((ref) {
      // สร้าง notifier
      final notifier = digitSummaryNotifier(ref);
      return notifier;
    });

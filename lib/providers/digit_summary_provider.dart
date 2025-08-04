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
  final int digit;
  digitSummaryNotifier(ref, this.digit) : super(digitSummaryState()) {
    _ref = ref;

    _waitForLotteryDate();
  }

  void _waitForLotteryDate() {
    // ฟัง provider จนกว่าจะได้ lotteryDate
    _ref.listen<lotteryDateState>(lotteryDateProvider, (prev, next) {
      if (next.lotteryDate != null && state.digitSummary == null) {
        _initWebsocket(next.lotteryDate!);
      }
    });
  }

  void _initWebsocket(LotteryDateAppwrite lotteryDate) async {
    // ถ้าต้องการฟังข้อมูลกลับมา:
    final data = await getDigitSummary(
      date: formatYMD(lotteryDate.dateTime),
      type: digit,
      lotteryDateId: lotteryDate.id,
    );
    state = state.copyWith(
      digit: digit,
      isLoading: false,
      error: null,
      digitSummary: data,
    );
    final ws = _ref.read(wsServiceProvider);
    ws.send({'room': 'digit_$digit'}, true);
    ws.stream.listen((msg) {
      // parse msg แล้ว update state ผ่าน state = ...
    });
  }

  // void setDigit(int newDigit) async {
  //   final oldRoom = state.digit;
  //   // TODO: Connect Sockets
  //   final wsService = _ref.read(wsServiceProvider);
  //   // TODO:leave old room
  //   wsService.send({'room': 'digit_$newDigit', "type": "leave"}, false);

  //   wsService.send({'room': 'digit_$newDigit'}, true);

  //   state = state.copyWith(digit: newDigit, isLoading: true, error: null);
  //   final lotteryDate = _ref.read(lotteryDateProvider).lotteryDate;
  //   final data = await getDigitSummary(
  //     date: formatYMD(lotteryDate!.dateTime),
  //     type: state.digit!,
  //     lotteryDateId: lotteryDate!.id,
  //   );
  //   state = state.copyWith(isLoading: false, error: null, digitSummary: data);
  // }

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
                dashboardType: '',
                quotaOne: 0,
                quotaTwo: 0,
                quotaThree: 0,
                quotaFour: 0,
                quotaFive: 0,
                quotaSix: 0,
              ),
      ),
    );

    // แล้วอัปเดต state
  }
}

/// 3) ประกาศ provider
final DigitSummaryProvider =
    StateNotifierProvider.family<digitSummaryNotifier, digitSummaryState, int>((
      ref,
      digit,
    ) {
      // สร้าง notifier
      final notifier = digitSummaryNotifier(ref, digit);
      return notifier;
    });

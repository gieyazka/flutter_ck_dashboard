import 'package:appwrite/models.dart';
import 'package:ck_dashboard/core/api/lottery_date.dart';
import 'package:ck_dashboard/core/appwrite_service.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/core/util.dart';
import 'package:ck_dashboard/models/SummaryDashboard_model.dart';
import 'package:ck_dashboard/models/appwrite_model.dart';
import 'package:ck_dashboard/models/digit_summary.dart';
import 'package:ck_dashboard/providers/lottery_date_provider.dart';
import 'package:ck_dashboard/providers/web_socker_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

/// 1) สร้าง state model เพื่อเก็บ loading / user / error
class SummaryState {
  final bool isLoading;
  final String? error;
  final int? digit;
  final SummaryDashboard? summaryDashboard;

  const SummaryState({
    this.isLoading = false,
    this.error,
    this.digit, // Default digit value
    this.summaryDashboard,
  });
  SummaryState copyWith({
    bool? isLoading,
    String? error,
    int? digit,
    SummaryDashboard? summaryDashboard,
  }) {
    return SummaryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      digit: digit ?? this.digit,
      summaryDashboard: summaryDashboard ?? this.summaryDashboard,
    );
  }
}

class SummaryNotifier extends StateNotifier<SummaryState> {
  late final Ref _ref;
  SummaryNotifier(ref) : super(SummaryState()) {
    _ref = ref;
    final lotteryDate = _ref.read(lotteryDateProvider).lotteryDate;
    _initWebsocket();
    // _loadSummary();
    logger.i('SummaryNotifier initialized');
  }

  void loadSummary() async {
    state = state.copyWith(isLoading: true, error: null);
    final lotteryDate = _ref.read(lotteryDateProvider).lotteryDate;
    final data = await getMainDashboard(lotteryDateId: lotteryDate!.id);
    state = state.copyWith(
      isLoading: false,
      error: null,
      summaryDashboard: data,
    );
  }

  void _initWebsocket() {
    final ws = _ref.read(wsServiceProvider);
    ws.send({'room': 'mainDashboard'}, true);
    // ถ้าต้องการฟังข้อมูลกลับมา:
    ws.stream.listen((msg) {
      // parse msg แล้ว update state ผ่าน state = ...
    });
  }

  void handleSocketData(Map<String, dynamic> data) {
    // final oldQuota = state.summaryDashboard?.quota;
    // final topAcc = data['topAccumulate'] as List<dynamic>?;
    // final bottomAcc = data['bottomAccumulate'] as List<dynamic>?;
    // final notBuyAcc = data['notBuyAccumulate'] as List<dynamic>?;
    // final fullQuta = data['notSellAccumulate'] as List<dynamic>?;
    // // final userCount = data["userCount"];
    // final dashboardSummary = data['dashboardSummary'] as Map<String, dynamic>?;

    // _ref
    //     .read(lotteryDateProvider.notifier)
    //     .setLotteryDate(LotteryDateAppwrite.fromJson(data["userCount"]));

    // state = state.copyWith(
    //   digitSummary: DigitSummary(
    //     digitQuota: oldQuota!,
    //     topAccumulate:
    //         topAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
    //     bottomAccumulate:
    //         bottomAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
    //     notBuyAccumulate:
    //         notBuyAcc?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
    //     fullQuota:
    //         fullQuta?.map((item) => Accumulate.fromJson(item)).toList() ?? [],
    //     dashboardSummary: dashboardSummary != null
    //         ? DashboardSummary.fromJson(dashboardSummary)
    //         : DashboardSummary(
    //             id: '',
    //             lotteryDateId: '',
    //             revenue: 0,
    //             type: 0,
    //             bankWinCost: 0,
    //             lotteryTsCost: 0,
    //             pointCost: 0,
    //             quota: 0,
    //           ),
    //   ),
    // );

    // แล้วอัปเดต state
  }
}

/// 3) ประกาศ provider
final SummaryProvider = StateNotifierProvider<SummaryNotifier, SummaryState>((
  ref,
) {
  // สร้าง notifier
  final notifier = SummaryNotifier(ref);

  ref.listen<lotteryDateState>(
    lotteryDateProvider,
    (previous, next) {
      // ถ้า id ไม่ null แสดงว่าโหลดข้อมูลได้
      if (next.lotteryDate?.id != null &&
          next.lotteryDate?.id.isNotEmpty == true) {
        notifier.loadSummary();
      }
    },
    // ถ้าต้องการให้ fire ครั้งแรกเมื่อมีค่าอยู่แล้ว ให้เป็น true
    fireImmediately: true,
  );

  return notifier;
});

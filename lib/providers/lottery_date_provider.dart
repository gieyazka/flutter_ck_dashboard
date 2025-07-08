import 'package:appwrite/models.dart';
import 'package:ck_dashboard/core/api/lottery_date.dart';
import 'package:ck_dashboard/core/appwrite_service.dart';
import 'package:ck_dashboard/models/appwrite_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

/// 1) สร้าง state model เพื่อเก็บ loading / user / error
class lotteryDateState {
  final bool isLoading;
  final String? error;
  final LotteryDateAppwrite? lotteryDate;
  const lotteryDateState({
    this.isLoading = false,
    this.error,
    this.lotteryDate,
  });

  lotteryDateState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    LotteryDateAppwrite? lotteryDate,
  }) {
    return lotteryDateState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lotteryDate: lotteryDate ?? this.lotteryDate,
    );
  }
}

/// 2) StateNotifier ที่จะ fetch user ตอนสร้าง
class lotteryDateNotifier extends StateNotifier<lotteryDateState> {
  lotteryDateNotifier() : super(lotteryDateState()) {
    _loadLotteryDate();
  }

  Future<void> _loadLotteryDate() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      state = state.copyWith(lotteryDate: await getNextLotteryDate());
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setLotteryDate(LotteryDateAppwrite newDate) {
    state = state.copyWith(lotteryDate: newDate);
  }

  Future<void> refresh() async {
    await _loadLotteryDate();
  }
}

/// 3) ประกาศ provider
final lotteryDateProvider =
    StateNotifierProvider<lotteryDateNotifier, lotteryDateState>((ref) {
      return lotteryDateNotifier();
    });

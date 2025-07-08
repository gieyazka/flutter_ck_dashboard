// Providers
import 'package:ck_dashboard/core/api/user.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeStateProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier();
});

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  


  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

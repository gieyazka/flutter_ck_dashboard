// Providers
import 'package:ck_dashboard/core/api/user.dart';
import 'package:ck_dashboard/core/logger.dart';
import 'package:ck_dashboard/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginStateProvider = StateNotifierProvider<LoginNotifier, HomeState>((
  ref,
) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<HomeState> {
  LoginNotifier() : super(const HomeState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter both username and password',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userDoc = await getUserByUsername(username: username);
      // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));
      final loginResponse = await createSession(
        email: userDoc.email,
        password: password,
      );
      // Simple validation for demo
      if (loginResponse.success) {
        // Login successful
        state = state.copyWith(isLoading: false);
        SnackBar snackBar = SnackBar(
          content: Text('Login successful for ${userDoc.username}'),
        );
        state = state.copyWith(isSuccess: true, errorMessage: null);
        logger.i('Login successful for ${userDoc.username}');
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'username or password is incorrect',
        );
      }
    } catch (e) {
      logger.e('Login error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while logging in',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

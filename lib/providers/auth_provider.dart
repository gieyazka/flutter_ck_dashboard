// lib/providers/auth_provider.dart
import 'package:appwrite/models.dart';
import 'package:ck_dashboard/core/appwrite_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

/// 1) สร้าง state model เพื่อเก็บ loading / user / error
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

/// 2) StateNotifier ที่จะ fetch user ตอนสร้าง
class AuthNotifier extends StateNotifier<AuthState> {
  final Client _client;
  late final Account _account;
  AuthNotifier(this._client) : super(const AuthState()) {
    _account = Account(_client);
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _account.get(); // <-- เรียก account.get()
      state = state.copyWith(user: user);
    } on AppwriteException catch (e) {
      state = state.copyWith(error: e.message);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// เมธอด logout
  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
    state = const AuthState(); // เคลียร์ state ทั้งหมด
  }
}

/// 3) ประกาศ provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final client = AppwriteService().client;
  return AuthNotifier(client);
});

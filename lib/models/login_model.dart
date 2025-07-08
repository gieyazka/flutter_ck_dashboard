class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final bool isPasswordVisible;
  final bool isSuccess;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.isPasswordVisible = false,
    this.isSuccess = false,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isPasswordVisible,
    bool? isSuccess,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

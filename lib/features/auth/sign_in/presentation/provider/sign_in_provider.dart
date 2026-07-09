import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../../core/services/local_storage_service.dart';
import '../../../repository/auth_repository.dart';


final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});



final tokenProvider = StateProvider<String?>((ref) => null);

final signInProvider = StateNotifierProvider<SignInNotifier, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInNotifier(authRepository, ref);
});

class SignInNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final Ref _ref;

  SignInNotifier(this._authRepository, this._ref) : super(const AsyncValue.data(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final token = await _authRepository.signIn(email: email, password: password);
      if (token != null) {
        await _ref.read(localStorageServiceProvider).saveToken(token);
      }
      _ref.read(tokenProvider.notifier).state = token;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

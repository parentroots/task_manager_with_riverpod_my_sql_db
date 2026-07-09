import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/app.dart';
import 'package:task_management/core/services/local_storage_service.dart';
import 'package:task_management/features/auth/sign_in/presentation/provider/sign_in_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);
  final savedToken = localStorageService.getToken();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(localStorageService),
        if (savedToken != null)
          tokenProvider.overrideWith((ref) => savedToken),
      ],
      child: const App(),
    ),
  );
}



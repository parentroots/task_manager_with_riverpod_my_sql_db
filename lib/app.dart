import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/core/theme/app_theme.dart';
import 'package:task_management/features/auth/sign_in/presentation/provider/sign_in_provider.dart';
import 'package:task_management/features/auth/sign_in/presentation/screen/sign_in_screen.dart';
import 'package:task_management/features/home/presentation/screen/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(tokenProvider);

    return MaterialApp(
      title: 'Task Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: token != null ? const HomeScreen() : const SignInScreen(),
    );
  }
}


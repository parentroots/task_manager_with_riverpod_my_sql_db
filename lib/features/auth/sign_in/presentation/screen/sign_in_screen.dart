import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../home/presentation/screen/home_screen.dart';
import '../provider/sign_in_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController emailTEController;
  late final TextEditingController passwordTEController;

  @override
  void initState() {
    super.initState();
    emailTEController = TextEditingController();
    passwordTEController = TextEditingController();
  }

  @override
  void dispose() {
    emailTEController.dispose();
    passwordTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the sign in state for navigation and errors
    ref.listen<AsyncValue<void>>(signInProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceAll("Exception: ", "")),
              backgroundColor: Colors.redAccent,
            ),
          );
        },
      );
    });

    final signInState = ref.watch(signInProvider);
    final isLoading = signInState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailTEController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordTEController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              enabled: !isLoading,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final email = emailTEController.text;
                      final password = passwordTEController.text;
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in all fields"),
                            backgroundColor: Colors.amber,
                          ),
                        );
                        return;
                      }
                      ref.read(signInProvider.notifier).signIn(
                            email: email,
                            password: password,
                          );
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tichafasta/pages/home_page.dart';
import 'auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithEmailAndPassword(email, password);
      // Navigation will occur automatically via AuthenticationWrapper,
      // but you can also use pushReplacement if needed:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              // Password Field
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Sign in with Email'),
                onPressed: _signInWithEmail,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.userCircle),
                label: const Text('Sign in with Google'),
                onPressed: () async {
                  try {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .signInWithGoogle();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Google sign in failed: $e')),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text("Don't have an account? Sign up"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

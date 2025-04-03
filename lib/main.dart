import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tichafasta/firebase_options.dart';
import 'auth/auth_provider.dart';
import 'auth/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MarkSheet Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // You can integrate shadcn_ui theming here if available.
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    return userAsync.when(
      data: (user) {
        return user != null ? HomePage() : LoginPage();
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}

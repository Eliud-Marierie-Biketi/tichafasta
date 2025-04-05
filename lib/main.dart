import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tichafasta/firebase_options.dart';
import 'package:tichafasta/pages/profile_page.dart';

import 'auth/auth_provider.dart';
import 'auth/login_page.dart';
import 'package:tichafasta/pages/dashboard_page.dart';
import 'package:tichafasta/pages/reports_page.dart';
import 'package:tichafasta/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check system theme (light/dark) preference
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return MaterialApp(
      title: 'MarkSheet Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        // Light theme settings
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 40, 231, 183),
          elevation: 7,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 40, 231, 183),
          elevation: 7,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Dark theme settings
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 7,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[850],
          elevation: 7,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
        ),
      ),
      themeMode:
          isDarkMode ? ThemeMode.dark : ThemeMode.light, // Choose theme mode
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
      error:
          (error, stack) =>
              Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}

// -------------------------------------------
// HOMEPAGE WITH NAVIGATION BAR AND APPBAR
// -------------------------------------------

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    ReportsPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 231, 183),
        elevation: 7,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Row(
          children: [
            Image.asset('assets/trans_bg.png', height: 80),
            SizedBox(width: 10),
            Text(
              'TichaFasta',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {
              // Handle notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: InkWell(
              onTap: () {
                // Navigate to the ProfilePage when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage:
                    FirebaseAuth.instance.currentUser?.photoURL != null
                        ? NetworkImage(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                        )
                        : AssetImage('assets/profile.png') as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.file),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(
          255,
          40,
          231,
          183,
        ), // Match appBar background color
        elevation: 7, // Same elevation as appBar
        selectedItemColor: Colors.white, // Selected item color (optional)
        unselectedItemColor: Colors.black,
        iconSize: 30, // Unselected item color (optional)
      ),
    );
  }
}

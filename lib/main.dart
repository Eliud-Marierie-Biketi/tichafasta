import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    as shadcn; // <-- Alias shadcn_flutter
import 'package:tichafasta/components/sidebar.dart';

import 'firebase_options.dart';
import 'auth/auth_provider.dart';
import 'auth/login_page.dart';
import 'pages/profile_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyShadcnApp()));
}

class MyShadcnApp extends ConsumerWidget {
  const MyShadcnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    return shadcn.ShadcnApp(
      title: 'Ticha Fasta',
      theme: shadcn.ThemeData(
        colorScheme:
            isDarkMode
                ? shadcn.ColorSchemes.darkZinc()
                : shadcn.ColorSchemes.lightZinc(),
        radius: 8.0, // Add the required radius parameter
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
      drawer: const Drawer(
        // 👈 sidebar appears from the left
        child: CustomSidebar(),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 231, 183),
        elevation: 7,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Row(
          children: [
            Builder(
              builder:
                  (context) => shadcn.OutlineButton(
                    density: shadcn.ButtonDensity.icon,
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // No more errors 🎯
                    },
                    child: const Icon(Icons.menu),
                  ),
            ),
            SizedBox(width: 10),
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

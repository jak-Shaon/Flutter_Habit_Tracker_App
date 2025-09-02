import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'habit/habit_list_screen.dart';
import 'quotes_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _pages = const [
    HabitListScreen(),
    QuotesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        // Check if user is logged in, if not navigate to login screen
        if (!auth.isLoggedIn) {
          // Use a post-frame callback to avoid navigation during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !auth.isLoggedIn) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Habit Tracker",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false, // keep it left aligned
            elevation: 4,
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: () async {
                  try {
                    await auth.logout();
                    // The navigation will be handled by the Consumer above
                    // when auth.isLoggedIn becomes false
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logout failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _pages[_index],
          ),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            child: NavigationBar(
              height: 60,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.checklist), label: 'Habits'),
                NavigationDestination(
                    icon: Icon(Icons.format_quote), label: 'Quotes'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
                NavigationDestination(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        );
      },
    );
  }
}

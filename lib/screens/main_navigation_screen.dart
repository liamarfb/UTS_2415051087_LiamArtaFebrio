import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import 'home_screen.dart';
import 'spot_list_screen.dart';
import 'saved_logs_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SpotListScreen(),
    SavedLogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              indicatorColor: AppConstants.primaryMint.withValues(alpha: 0.2),
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  Icons.flight_takeoff,
                  color: AppConstants.primaryMint,
                  size: 32,
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Spot Cuaca'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: Text('Flight Log'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: Colors.white,
        indicatorColor: AppConstants.primaryMint.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Spot Cuaca',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Flight Log',
          ),
        ],
      ),
    );
  }
}
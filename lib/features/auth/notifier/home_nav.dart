import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentride/features/auth/notifier/auth_session.dart';
import 'package:studentride/features/home/screen/driver_home_screen.dart';
import 'package:studentride/features/home/screen/home_screen.dart';
import 'package:studentride/features/profile/screens/profile_screen.dart';

class StudentRideApp extends StatefulWidget {
  const StudentRideApp({super.key});

  @override
  State<StudentRideApp> createState() => _StudentRideAppState();
}

class _StudentRideAppState extends State<StudentRideApp> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthSession>(
      builder: (context, authProvider, _) {
        final isDriver = authProvider.isDriver;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: isDriver ? _getDriverScreens() : _getPassengerScreens(),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue[600],
              unselectedItemColor: Colors.grey[600],
              selectedFontSize: 12,
              unselectedFontSize: 11,
              elevation: 0,
              backgroundColor: Colors.white,
              items: isDriver ? _getDriverNavItems() : _getPassengerNavItems(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _getDriverScreens() {
    return [
      const DriverHomeScreen(),
      Container(
        color: Colors.white,
        child: const Center(child: Text('My Rides')),
      ),
      Container(
        color: Colors.white,
        child: const Center(child: Text('Earnings')),
      ),
      ProfileScreen(),
    ];
  }

  List<Widget> _getPassengerScreens() {
    return [
      const HomeScreen(),
      Container(
        color: Colors.white,
        child: const Center(child: Text('Rides History')),
      ),
      Container(
        color: Colors.white,
        child: const Center(child: Text('Student Info')),
      ),
      ProfileScreen(),
    ];
  }

  List<BottomNavigationBarItem> _getDriverNavItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.directions_car_outlined),
        activeIcon: Icon(Icons.directions_car),
        label: 'My Rides',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet_outlined),
        activeIcon: Icon(Icons.account_balance_wallet),
        label: 'Earnings',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  List<BottomNavigationBarItem> _getPassengerNavItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.history_outlined),
        activeIcon: Icon(Icons.history),
        label: 'Rides',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.school_outlined),
        activeIcon: Icon(Icons.school),
        label: 'Student',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
}

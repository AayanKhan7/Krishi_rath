// dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
import 'package:krishi_rath/features/diary/screens/diary_screen.dart';
import 'package:krishi_rath/features/home/screens/home_screen.dart';
import 'package:krishi_rath/features/profile/screens/profile_screen.dart';
import 'package:krishi_rath/features/schemes/screens/schemes_screen.dart';
import 'package:krishi_rath/features/updates/screens/updates_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  Position? _currentPosition; // Variable to store the location
  bool _isLoading = true; // Loading state

  // We will build the list of screens after we get the location
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _getLocationAndSetupScreens();
  }

  // New method to handle permissions and get location
  Future<void> _getLocationAndSetupScreens() async {
    // 1. Check for permission
    PermissionStatus status = await Permission.location.status;

    // 2. If permission is not granted, request it
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    // 3. Handle the permission result
    if (status.isGranted) {
      try {
        // Get the current location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
        });
        print('Location fetched: Lat: ${position.latitude}, Long: ${position.longitude}');
      } catch (e) {
        print("Error fetching location: $e");
        // Handle error (e.g., location services are disabled)
      }
    } else {
      print("Location permission denied by user.");
      // Handle denial (e.g., show a message or use a default location)
    }

    // 4. Initialize the screens list (this happens after location is fetched or denied)
    _widgetOptions = <Widget>[
      HomeScreen(position: _currentPosition), // Pass the position to HomeScreen
      const SchemesScreen(),
      const UpdatesScreen(),
      const DiaryScreen(),
      const ProfileScreen(),
    ];

    // 5. Turn off the loading indicator
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading circle while we get the location
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    double iconSize = screenWidth * 0.07;
    iconSize = iconSize.clamp(20, 35);

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: iconSize),
            activeIcon: Icon(Icons.home, size: iconSize),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined, size: iconSize),
            activeIcon: Icon(Icons.account_balance, size: iconSize),
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined, size: iconSize),
            activeIcon: Icon(Icons.notifications, size: iconSize),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined, size: iconSize),
            activeIcon: Icon(Icons.book, size: iconSize),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: iconSize),
            activeIcon: Icon(Icons.settings, size: iconSize),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: screenWidth * 0.035),
        unselectedLabelStyle: TextStyle(fontSize: screenWidth * 0.032),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/ui/History/History.dart';
import 'package:ipay/ui/Home/screens/Home.dart';
import 'package:ipay/ui/Offers/Offers.dart';
import 'package:ipay/ui/Profile/Profile.dart';
import '../../providers/BottomProvider.dart'; // Import the provider

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the provider instance
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    // List of screens to be displayed
    List<Widget> pages = [
      const HomeScreen(),
      const HistoryScreen(),
      const OffersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // Use the currentIndex from the provider
      body: IndexedStack(
        index: bottomNavProvider.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // Use the currentIndex from the provider
        currentIndex: bottomNavProvider.currentIndex,
        // Call the provider's method to update the index
        onTap: (index) => bottomNavProvider.setCurrentIndex(index),
        selectedItemColor: IpayColor.primaryColor,
        unselectedItemColor: IpayColor.textSecondaryColor,
        backgroundColor: Colors.grey.shade300,
        elevation: 4,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
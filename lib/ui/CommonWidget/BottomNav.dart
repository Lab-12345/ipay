import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/providers/BottomProvider.dart';
import 'package:ipay/ui/Home/screens/HomeScreen.dart';
import 'package:ipay/ui/Wallat/screens/IPayWalletsScreen.dart';
import 'package:ipay/ui/Recharge/MobileRecharge/MobileRecharge.dart';
import 'package:ipay/ui/Offers/Offers.dart';
import 'package:ipay/ui/Profile/Profile.dart';

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    List<Widget> pages = [
      const IPayHomeScreen(),
      Ipaywalletsscreen(),
      const Mobilerecharge(),
      const OffersScreen(),
      SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: bottomNavProvider.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavProvider.currentIndex,
        onTap: (index) => bottomNavProvider.setCurrentIndex(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: IpayColor.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Recharge',
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

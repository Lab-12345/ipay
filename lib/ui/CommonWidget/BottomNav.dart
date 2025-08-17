import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/ui/Offers/Offers.dart';
import 'package:ipay/ui/Profile/Profile.dart';
import '../../providers/BottomProvider.dart';
import '../History/screens/History.dart';
import '../Home/screens/HomeScreen.dart';

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    List<Widget> pages = [
      IPayHomeScreen(),
      HistoryScreen(),
      SizedBox.shrink(),
      OffersScreen(),
      SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: bottomNavProvider.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        shape: const CircularNotchedRectangle(),
        notchMargin: 3.0,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side items
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: bottomNavProvider.currentIndex == 0
                      ? IpayColor.primaryColor
                      : Colors.grey[525],
                ),
                onPressed: () => bottomNavProvider.setCurrentIndex(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.receipt_long_outlined,
                  color: bottomNavProvider.currentIndex == 1
                      ? IpayColor.primaryColor
                      : Colors.grey[525],
                ),
                onPressed: () => bottomNavProvider.setCurrentIndex(1),
              ),
              const SizedBox(width: 40), /// space for center button
              IconButton(
                icon: Icon(
                  Icons.local_offer,
                  color: bottomNavProvider.currentIndex == 3
                      ? IpayColor.primaryColor
                      : Colors.grey[525],
                ),
                onPressed: () => bottomNavProvider.setCurrentIndex(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: bottomNavProvider.currentIndex == 4
                      ? IpayColor.primaryColor
                      : Colors.grey[515],
                ),
                onPressed: () => bottomNavProvider.setCurrentIndex(4),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E3A59),
        shape: const CircleBorder(),
        onPressed: () => bottomNavProvider.setCurrentIndex(2),
        child: const Icon(
          Icons.qr_code_scanner,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/ui/Offers/Offers.dart';
import 'package:ipay/ui/Profile/Profile.dart';

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    List<Widget> pages = [
    ];

    return Scaffold(
      body: IndexedStack(
        index: bottomNavProvider.currentIndex,
        children: pages,
      ),
                ),
              ),
                ),
              ),
            ],
          ),
    );
  }
}
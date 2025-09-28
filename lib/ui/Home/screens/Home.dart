import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Profile/Profile.dart';
// Import the provider

import '../../../providers/HomeProvider.dart';
import '../widgets/PopularServicesGrid.dart';
import '../widgets/QuickRechargeGrid.dart';
import '../widgets/SectionHeading.dart';
import '../widgets/TransactionsHistory.dart';

// Convert StatefulWidget to StatelessWidget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the data from the HomeProvider
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: IpayColor.primaryBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: IpayColor.primaryColor,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: Column(
        children: [
          /// Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [IpayColor.primaryColor, IpayColor.primaryColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(IpaySize.lg),
                child: Column(
                  children: [
                    /// Header Top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IpayHelper.CustomText(
                          text: 'IPay',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: IpayColor.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: IpaySize.defaultSpace - 4),

                    /// Wallet Balance Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg),
                      ),
                      padding: const EdgeInsets.all(IpaySize.lg),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd+2),
                            ),
                            padding: const EdgeInsets.all(IpaySize.md-2),
                            child: const Text(
                              '💳',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: IpaySize.spaceBtwItems),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wallet Balance',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                                // Accessing the wallet balance from the provider
                                Text(
                                  '₹${homeProvider.walletBalance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(IpaySize.borderRadiusXL),
                            ),
                            padding: const EdgeInsets.all(IpaySize.sm+2),
                            child: const Text(
                              '👤',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(IpaySize.md+2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Quick Recharge Section
                  SectionHeading(
                    title: 'Quick Recharge',
                    actionText: 'View All',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: IpaySize.spaceBtwItems),
                  // Pass data from provider to the widget
                  QuickRechargeGrid(
                    quickRechargeServices: homeProvider.quickRechargeServices,
                  ),
                  const SizedBox(height: IpaySize.spaceBtwSections),

                  /// Promotional Banner
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        IpaySize.borderRadiusMd,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCD34D),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(IpaySize.sm + 2),
                          child: const Text(
                            '💰',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IpayHelper.CustomText(
                              text: 'Get 20% Off',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            IpayHelper.CustomText(
                              text: 'on your first recharge',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: IpaySize.defaultSpace),

                  /// Popular Services Section
                  const SectionHeading(
                    title: 'Popular Services',
                    actionText: 'See More',
                  ),
                  const SizedBox(height: IpaySize.spaceBtwItems),
                  // Pass data from provider to the widget
                  PopularServicesGrid(
                    popularServices: homeProvider.popularServices,
                  ),
                  const SizedBox(height: IpaySize.defaultSpace),

                  /// Recent Transactions Section
                  const SectionHeading(
                    title: 'Recent Transactions',
                    actionText: 'View All',
                  ),
                  const SizedBox(height: IpaySize.spaceBtwItems),
                  // Pass data from provider to the widget
                  TransactionsHistory(
                    recentTransactions: homeProvider.recentTransactions,
                  ),
                  const SizedBox(height: IpaySize.spaceBtwSections),

                  /// Add Money Banner
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        IpaySize.borderRadiusMd + 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(IpaySize.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IpayHelper.CustomText(
                              text: 'Add Money to Wallet',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: IpaySize.spaceBtwItemsSm - 2,
                            ),
                            IpayHelper.CustomText(
                              text: 'Instant wallet top-up available',
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              IpaySize.borderRadiusXL,
                            ),
                          ),
                          padding: const EdgeInsets.all(IpaySize.sm),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

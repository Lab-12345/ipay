import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipay/ui/Home/widgets/SectionHeading.dart';
import 'package:ipay/ui/Recharge/MobileRecharge/MobileRecharge.dart';
import 'package:provider/provider.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import '../../../core/constants/app_Helper_Function.dart';
import '../../../providers/IpayHomeProvider.dart';
import '../../Recharge/DTHRecharge/DTHRecharges.dart';
import '../../Recharge/LPG/LPGInputs.dart';
import '../../Recharge/LPG/LPGRecharge.dart';
import '../dailogs/RechageMenu.dart';
import '../dailogs/RechargeBottomSheet.dart';
import '../widgets/Wallet.dart';
import 'package:ipay/providers/WalletProvider.dart';
import 'package:ipay/providers/auth_provider.dart';
import 'package:ipay/ui/Wallat/screens/IPayWalletsScreen.dart';

class IPayHomeScreen extends StatelessWidget {
  const IPayHomeScreen({super.key});

  void _onServiceTap(BuildContext context, String serviceName) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$serviceName selected'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showBillPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RechargeBottomSheet(), // Use the RechargeBottomSheet widget
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Logo
              Padding(
                padding: const EdgeInsets.all(IpaySize.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: IpayColor.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: IpayHelper.CustomText(
                              text: 'I',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IpayHelper.CustomText(
                          text: 'Pay',
                          fontSize: 24,
                          color: IpayColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('Hello!'),
                        SizedBox(width: 3),
                        Text('User'),
                      ],
                    ),
                  ],
                ),
              ),

              // Promotional Banner
              SizedBox(
                height: 180,
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                    return PageView(
                      controller: homeProvider.pageController,
                      onPageChanged: (index) {
                        homeProvider.updateCurrentPage(index);
                      },
                      children: [
                        _buildPromoBanner(theme),
                        _buildPromoBanner(theme, isSecondary: true),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: IpaySize.spaceBtwItems),

              // Page Indicators
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: IpaySize.xs,
                        ),
                        width: IpaySize.spaceBtwItemsSm,
                        height: IpaySize.spaceBtwItemsSm,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: homeProvider.currentPage == index
                              ? IpayColor.primaryColor
                              : Colors.grey.shade300,
                        ),
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: IpaySize.spaceBtwItemsSm + 3),
              Padding(
                padding: const EdgeInsets.all(IpaySize.spaceBtwItems),
                child: Consumer2<IpayWalletProvider, PhoneAuthProvider>(
                  builder: (context, wallet, auth, _) {
                    return HomeWalletContainer(
                      balance: wallet.balance,
                      onAddMoney: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ipaywalletsscreen(),
                          ),
                        ).then((_) {
                          wallet.refreshBalance(context);
                        });
                      },
                    );
                  },
                ),
              ),
              // Online Recharge Section
              Padding(
                padding: const EdgeInsets.only(
                  left: IpaySize.md,
                  right: IpaySize.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(
                      title: 'Recharge',
                      actionText: 'View All',
                      onPressed: () {
                        showBillPaymentBottomSheet(context);
                      },
                    ),
                    const SizedBox(height: IpaySize.defaultSpace),

                    // Recharge Services Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildServiceItem(
                          context,
                          icon: Icons.smartphone,
                          label: 'Mobile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Mobilerecharge(),
                              ),
                            );
                          },
                        ),
                        _buildServiceItem(
                          context,
                          icon: Icons.satellite_alt,
                          label: 'DTH\nRecharge',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DthRecharges(),
                              ),
                            );
                          },
                        ),
                        _buildServiceItem(
                          context,
                          icon: Icons.light,
                          label: 'Electricity',
                          onTap: () => _onServiceTap(context, 'Electricity'),
                        ),
                        _buildServiceItem(
                          context,
                          icon: Icons.speed,
                          label: 'Fastag',
                          onTap: () => _onServiceTap(context, 'Fastag'),
                        ),
                      ],
                    ),

                    // Page indicator for recharge services
                    const SizedBox(height: IpaySize.spaceBtwItems),
                    Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: IpaySize.spaceBtwItemsSm),

              // Bill Payments Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: IpaySize.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(title: 'Bill Payment', actionText: ''),

                    const SizedBox(height: IpaySize.defaultSpace),

                    /// Bill Payment Services Grid
                    Column(
                      children: [
                        // Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildServiceItem(
                              context,
                              icon: Icons.wifi,
                              label: "BroadBand",
                              onTap: () => _onServiceTap(context, 'BroadBand'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.local_gas_station,
                              label: 'Gas Bill',
                              onTap: () => _onServiceTap(context, 'Gas Bill'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.water_drop,
                              label: 'Water Bill',
                              onTap: () => _onServiceTap(context, 'Water Bill'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.wifi,
                              label: 'Broadband',
                              onTap: () => _onServiceTap(context, 'Broadband'),
                            ),
                          ],
                        ),

                        const SizedBox(height: IpaySize.defaultSpace),

                        // Row 2
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildServiceItem(
                              context,
                              icon: Icons.phone,
                              label: 'Landline',
                              onTap: () => _onServiceTap(context, 'Landline'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.school,
                              label: 'Loan EMI',
                              onTap: () => _onServiceTap(context, 'Loan EMI'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.propane_tank,
                              label: 'LPG Cylinder',
                              onTap: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LpgScreen(),
                                    ),
                                  ),
                              //_onServiceTap(context, 'LPG Cylinder'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.security,
                              label: 'Piped Gas',
                              onTap: () => _onServiceTap(context, 'Piped Gas'),
                            ),
                          ],
                        ),

                        const SizedBox(height: IpaySize.defaultSpace),

                        // Row 3
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildServiceItem(
                              context,
                              icon: Icons.account_balance,
                              label: 'Municipal\nTaxes',
                              onTap: () =>
                                  _onServiceTap(context, 'Municipal Taxes'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.tv,
                              label: 'Cable\nTV',
                              onTap: () => _onServiceTap(context, 'Cable TV'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.home,
                              label: 'Property\nTaxes',
                              onTap: () =>
                                  _onServiceTap(context, 'Property Taxes'),
                            ),
                            _buildServiceItem(
                              context,
                              icon: Icons.local_hospital,
                              label: 'Hospitals',
                              onTap: () => _onServiceTap(context, 'Hospitals'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(ThemeData theme, {bool isSecondary = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: IpaySize.md),
      padding: const EdgeInsets.all(IpaySize.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSecondary
              ? [Colors.purple.shade100, Colors.blue.shade100]
              : [Colors.blue.shade100, Colors.cyan.shade100],
        ),
        borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg),
      ),
      child: Row(
        children: [
          // Illustration
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  // Phone illustration
                  Positioned(
                    left: 20,
                    top: 10,
                    child: Container(
                      width: 60,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: IpaySize.spaceBtwItemsSm),
                          Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                IpaySize.borderRadiusSm,
                              ),
                            ),
                          ),
                          const SizedBox(height: IpaySize.spaceBtwItemsSm),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(
                                IpaySize.borderRadiusMd,
                              ),
                            ),
                            child: Icon(
                              Icons.phone_android,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2),
                              borderRadius: BorderRadius.circular(
                                IpaySize.borderRadiusSm,
                              ),
                            ),
                          ),
                          const SizedBox(height: IpaySize.spaceBtwItemsSm),
                        ],
                      ),
                    ),
                  ),
                  // Hand illustration
                  Positioned(
                    right: 10,
                    bottom: 0,
                    child: Container(
                      width: 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  // Decorative elements
                  Positioned(
                    right: 30,
                    top: 20,
                    child: Icon(
                      Icons.wifi,
                      color: Colors.blue.shade300,
                      size: IpaySize.iconSm,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Text Content
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    isSecondary
                        ? 'Pay Bills & Get Rewards'
                        : 'Recharge more than Rs. 200 &',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: IpaySize.spaceBtwItemsSm / 2),

                Flexible(
                  child: Text(
                    isSecondary ? 'Earn 15% Cashback' : 'Get 30% Cashback',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E3A59),
                    ),
                  ),
                ),

                const SizedBox(height: IpaySize.spaceBtwItemsMd),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: IpaySize.sm + 2,
                    vertical: IpaySize.xs,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(
                      IpaySize.borderRadiusMd,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IpayHelper.CustomText(
                        text: 'Prome',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(width: IpaySize.spaceBtwItemsSm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: IpaySize.sm,
                          vertical: IpaySize.xs - 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            IpaySize.spaceBtwItemsMd,
                          ),
                        ),
                        child: IpayHelper.CustomText(
                          text: isSecondary ? 'BILLS' : 'GET30',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF4A90E2)),
          ),

          const SizedBox(height: IpaySize.spaceBtwItemsSm),

          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

}

class BillPaymentBottomSheet {
}
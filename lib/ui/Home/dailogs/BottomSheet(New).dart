import 'package:flutter/material.dart';
import 'package:ipay/ui/Recharge/DTHRecharge/DTHRecharges.dart';
import 'package:ipay/ui/Recharge/LPG/LPGInputs.dart';
import 'package:ipay/ui/Recharge/LPG/LPGRecharge.dart';
import 'package:ipay/ui/Recharge/MobileRecharge/MobileRecharge.dart';

/// ---------- MAIN CLASS ----------
class BillPaymentBottomSheet extends StatelessWidget {
  const BillPaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF5F7FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --------- HEADER ---------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bill Payments & Recharges',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      Icon(Icons.payment, color: Colors.blue[700], size: 30),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// --------- POPULAR ---------
                  _buildCategory('Popular', [
                    _buildStyledIconText(
                      'Mobile Postpaid',
                      Icons.phone,
                      Colors.green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Mobilerecharge(),
                          ),
                        );
                      },
                    ),
                    _buildStyledIconText(
                      'FastTag Recharge',
                      Icons.local_taxi,
                      Colors.orange,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FastTagScreen(),
                          ),
                        );
                      },
                    ),
                    _buildStyledIconText(
                      'DTH/TV Recharge',
                      Icons.tv,
                      Colors.red,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DthRecharges(),
                          ),
                        );
                      },
                    ),
                  ]),

                  /// --------- UTILITIES ---------
                  _buildCategory('Utilities', [
                    _buildStyledIconText(
                      'Piped Gas',
                      Icons.local_gas_station,
                      Colors.blue,
                      () {},
                    ),
                    _buildStyledIconText(
                      'LPG Booking',
                      Icons.fire_extinguisher,
                      Colors.red,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LpgScreen()),
                        );
                      },
                    ),
                    _buildStyledIconText(
                      'Water',
                      Icons.water_drop,
                      Colors.cyan,
                      () {},
                    ),
                    _buildStyledIconText(
                      'Electricity',
                      Icons.lightbulb,
                      Colors.yellow,
                      () {},
                    ),
                    _buildStyledIconText(
                      'Postpaid',
                      Icons.receipt,
                      Colors.grey,
                      () {},
                    ),
                    _buildStyledIconText(
                      'Broadband',
                      Icons.wifi,
                      Colors.teal,
                      () {},
                    ),
                    _buildStyledIconText(
                      'Cable TV',
                      Icons.tv,
                      Colors.purple,
                      () {},
                    ),
                    _buildStyledIconText(
                      'DataCard Prepaid',
                      Icons.signal_wifi_4_bar,
                      Colors.indigo,
                      () {},
                    ),
                  ]),

                  /// --------- OTHERS ---------
                  _buildCategory('Others', [
                    _buildStyledIconText(
                      'EMI Payment',
                      Icons.payment,
                      Colors.green,
                      () {},
                    ),
                    _buildStyledIconText(
                      'LIC/Insurance',
                      Icons.shield,
                      Colors.blue,
                      () {},
                    ),
                    _buildStyledIconText(
                      'Municipality',
                      Icons.account_balance,
                      Colors.brown,
                      () {},
                    ),
                  ]),

                  const SizedBox(height: 20),

                  /// --------- POWERED BY ---------
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(width: 8),
                        Text(
                          'Powered by Bharat Connect',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------- CATEGORY WIDGET ----------
  Widget _buildCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Wrap(spacing: 20.0, runSpacing: 20.0, children: items),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// ---------- STYLED CONTAINER WIDGET ----------
  Widget _buildStyledIconText(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- HOW TO SHOW THE BOTTOM SHEET ----------
void showBillPaymentBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const BillPaymentBottomSheet(),
  );
}

/// ---------- DUMMY SCREENS FOR DEMO ----------
class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mobile Postpaid")),
      body: const Center(child: Text("Mobile Postpaid Screen")),
    );
  }
}

class FastTagScreen extends StatelessWidget {
  const FastTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FastTag Recharge")),
      body: const Center(child: Text("FastTag Recharge Screen")),
    );
  }
}

class DthScreen extends StatelessWidget {
  const DthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DTH Recharge")),
      body: const Center(child: Text("DTH/TV Recharge Screen")),
    );
  }
}

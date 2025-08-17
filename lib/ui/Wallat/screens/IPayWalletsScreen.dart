// lib/ui/Wallat/screens/Ipaywalletsscreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Home/widgets/SectionHeading.dart';
import 'package:ipay/ui/Home/widgets/TransactionsHistory.dart';
import 'package:ipay/ui/Wallat/screens/AddMoney.dart';
// Import the provider

import '../../../providers/AddMoneyProvider.dart';
import '../../../providers/WalletProvider.dart';
import '../widgets/WalletAppbar.dart';

class Ipaywalletsscreen extends StatefulWidget {
  Ipaywalletsscreen({super.key});

  @override
  State<Ipaywalletsscreen> createState() => _IpaywalletsscreenState();
}

class _IpaywalletsscreenState extends State<Ipaywalletsscreen> {
  @override
  void initState() {
    super.initState();
    // Trigger refresh once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final walletProvider = Provider.of<IpayWalletProvider>(context, listen: false);
        walletProvider.refreshBalance(context);
        walletProvider.fetchTransactions(context);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider here. The UI will now rebuild whenever the provider's data changes.
    final walletProvider = Provider.of<IpayWalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            const Text('Wallets'),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person_2_outlined),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(IpaySize.spaceBtwItems - 8),
          child: Column(
            children: [
              const IpayCreditCardWidget(
                cardNumber: '**** **** **** 5678',
                validThru: '12/26',
                cvv: '123',
                primaryColor: Color(0xFF1E88E5),
                secondaryColor: Color(0xFF1565C0),
              ),
              const SizedBox(height: IpaySize.spaceBtwItems),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                        create: (context) => AddMoneyProvider(),
                    child: const AddMoneyToWalletScreen(),),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(width: IpaySize.spaceBtwItemsSm-2),
                      const Text('Add Money'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: IpaySize.spaceBtwItemsSm + 2),
              Card(
                elevation: 3,
                shadowColor: Colors.black12,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: SectionHeading(title: 'Transaction History'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // Use the data from the provider.
                        child: TransactionsHistory(
                            recentTransactions: walletProvider.recentTransactions,
                            loading: walletProvider.txLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
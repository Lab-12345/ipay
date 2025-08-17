// HistoryScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/History/dialogs/FiltterDialogs.dart';

import '../../../providers/HistoryProvider.dart';
import '../dialogs/HistoryDetailsBottomSheet.dart'; // Import the provider
 // Import the bottom sheet widget

// TransactionsHistory
class TransactionsHistory extends StatelessWidget {
  const TransactionsHistory({super.key, required this.transaction});

  final Transaction transaction;

  // This method shows the bottom sheet
  void _showTransactionDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TransactionDetailsBottomSheet(
          amount: transaction.amount,
          transactionId: transaction.transactionId,
          date: transaction.date,
          time: transaction.time,
          status: transaction.status,
          paymentMethod: 'UPI', // Assuming a payment method for all
          transactionType: transaction.title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire Container with a GestureDetector to make it tappable
    return GestureDetector(
      onTap: () => _showTransactionDetails(context),
      child: Container(
        margin: EdgeInsets.only(bottom: IpaySize.sm + 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(IpaySize.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
              ),
              child: Center(
                child: Icon(
                  transaction.icon,
                  color: transaction.iconColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: IpaySize.spaceBtwItems),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IpayHelper.CustomText(
                    text: transaction.title,
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  if (transaction.subtitle.isNotEmpty)
                    IpayHelper.CustomText(
                      text: transaction.subtitle,
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.normal,
                    ),
                  IpayHelper.CustomText(
                    text: transaction.transactionId,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: IpaySize.spaceBtwItemsSm / 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      transaction.status.toLowerCase() == 'confirmed'
                          ? Icons.check_circle
                          : transaction.status.toLowerCase() == 'failed'
                          ? Icons.error
                          : Icons.hourglass_empty,
                      size: 16,
                      color: transaction.status.toLowerCase() == 'confirmed'
                          ? IpayColor.successColor
                          : transaction.status.toLowerCase() == 'failed'
                          ? IpayColor.warningColor
                          : Colors.orange,
                    ),
                    SizedBox(width: IpaySize.spaceBtwItemsSm / 2),
                    Text(
                      transaction.status.toLowerCase() == 'confirmed'
                          ? 'Success'
                          : transaction.status.toLowerCase() == 'failed'
                          ? 'Failed'
                          : 'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: transaction.status.toLowerCase() == 'confirmed'
                            ? IpayColor.successColor
                            : transaction.status.toLowerCase() == 'failed'
                            ? IpayColor.warningColor
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
                IpayHelper.CustomText(
                  text: '${transaction.date} ${transaction.time}',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Access the provider to get current filter state
        final provider = Provider.of<HistoryProvider>(context, listen: false);
        return FilterDialog(
          selectedPeriod: provider.selectedPeriod,
          selectedStatus: provider.selectedStatus,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: IpaySize.md, left: IpaySize.md),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg + 5),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Search transaction',
                  hintStyle: const TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.black54,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: IpaySize.sm + 2),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _showFilterDialog(context),
                    icon: const Icon(Icons.tune, color: Colors.black54),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: IpaySize.md,
                    vertical: IpaySize.md,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          // Check if any filters are applied
          final isFilterApplied = provider.selectedStatus != 'All' || provider.selectedPeriod != 'This week';

          if (provider.filteredTransactions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 100,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Transactions Yet!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Looks like your transaction history is empty. Start making transactions to see them here.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EDC5C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Start a Transaction',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: [
                if (isFilterApplied)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: IpaySize.spaceBtwItems,bottom: IpaySize.spaceBtwItemsMd-5),
                    padding: const EdgeInsets.all(IpaySize.spaceBtwItems),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        const Text(
                          'Filters applied',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => provider.clearFilters(),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = provider.filteredTransactions[index];
                      // Pass the transaction object to the TransactionsHistory widget
                      return TransactionsHistory(transaction: transaction);
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
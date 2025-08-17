// TransactionDetailsBottomSheet.dart
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_constants.dart';

// You can define a custom color class if you have one
class AppColor {
  static const Color primary = Color(0xFF6EDC5C); // Example color
}

class TransactionDetailsBottomSheet extends StatelessWidget {
  final String amount;
  final String transactionId;
  final String date;
  final String time;
  final String status;
  final String paymentMethod;
  final String transactionType; // E.g., "Wallet Deposits"

  const TransactionDetailsBottomSheet({
    super.key,
    required this.amount,
    required this.transactionId,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentMethod,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    bool isPending = status.toLowerCase() == 'pending';
    bool isFailed = status.toLowerCase() == 'failed';

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: IpaySize.defaultSpace),
            _buildAmountSection(isPending),
            const SizedBox(height: IpaySize.spaceBtwItems),
            if (isPending || isFailed) _buildStatusWarningCard(isPending, isFailed),
            const SizedBox(height: IpaySize.defaultSpace),
            _buildDetailsSection(),
            const SizedBox(height: IpaySize.spaceBtwSections),
            _buildFooterButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'More Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildAmountSection(bool isPending) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20,),
                if (isPending)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ],
        ),
        ///
        ///
        /// Spacial Widgets

      ],
    );
  }

  Widget _buildStatusWarningCard(bool isPending, bool isFailed) {
    Color cardColor = isPending ? const Color(0xFFFFF7E6) : Colors.red.shade50;
    Color textColor = isPending ? const Color(0xFFFFA500) : Colors.red.shade700;
    String message = isPending ? 'This transaction was pending' : 'This transaction failed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow('Transaction ID', transactionId),
        _buildDetailRow('Date & Time', '$date $time'),
        _buildDetailRow('Payment Method', paymentMethod),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Handle "Need Support?" action
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.grey.shade800,
              side: BorderSide(color: Colors.grey.shade500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Need Support?'),
          ),
        ),
        const SizedBox(width: IpaySize.spaceBtwItems),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.pink.shade50,
              foregroundColor: Colors.pink.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
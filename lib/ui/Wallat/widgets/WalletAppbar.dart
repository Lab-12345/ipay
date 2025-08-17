import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';

import '../../../core/constants/app_color.dart';

class IpayCreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String validThru;
  final String cvv;
  final String cardholderName;
  final Color primaryColor;
  final Color secondaryColor;

  const IpayCreditCardWidget({
    Key? key,
    this.cardNumber = '**** **** **** 1234',
    this.validThru = '01/25',
    this.cvv = '345',
    this.cardholderName = 'JOHN DOE',
    this.primaryColor = const Color(0xFF6C63FF),
    this.secondaryColor = const Color(0xFF4A47A3),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 220,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, secondaryColor, Color(0xFF2E1B69)],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.091),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Number Label and Number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD NUMBER',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cardNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Row - Valid, CVV, and Mastercard
                  Row(
                    children: [
                      // Valid Thru
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALID',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            validThru,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 40),

                      // CVV
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CVV',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cvv,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Mastercard Logo
                      //_buildMastercardLogo(),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: IpayColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'I',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IpayHelper. CustomText(text:
                            'Pay',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 50,
      height: 30,
      child: Stack(
        children: [
          // Left circle (Red)
          Positioned(
            left: 5,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Right circle (Yellow/Orange)
          Positioned(
            right: 5,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage Example with different card variations
class CreditCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Credit Cards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Default Purple Card
            const IpayCreditCardWidget(),

            // Blue Variant
            const IpayCreditCardWidget(
              cardNumber: '**** **** **** 5678',
              validThru: '12/26',
              cvv: '123',
              primaryColor: Color(0xFF1E88E5),
              secondaryColor: Color(0xFF1565C0),
            ),

            // Green Variant
            const IpayCreditCardWidget(
              cardNumber: '**** **** **** 9012',
              validThru: '08/27',
              cvv: '789',
              primaryColor: Color(0xFF43A047),
              secondaryColor: Color(0xFF2E7D32),
            ),

            // Pink Variant
            const IpayCreditCardWidget(
              cardNumber: '**** **** **** 3456',
              validThru: '06/28',
              cvv: '456',
              primaryColor: Color(0xFFE91E63),
              secondaryColor: Color(0xFFC2185B),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Alternative Horizontal Scrollable Cards
class CreditCardCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PageView(
        padEnds: false,
        controller: PageController(viewportFraction: 0.85),
        children: const [
          IpayCreditCardWidget(),
          IpayCreditCardWidget(
            cardNumber: '**** **** **** 5678',
            validThru: '12/26',
            cvv: '123',
            primaryColor: Color(0xFF1E88E5),
            secondaryColor: Color(0xFF1565C0),
          ),
          IpayCreditCardWidget(
            cardNumber: '**** **** **** 9012',
            validThru: '08/27',
            cvv: '789',
            primaryColor: Color(0xFF43A047),
            secondaryColor: Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }
}

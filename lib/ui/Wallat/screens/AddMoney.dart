// lib/ui/Wallat/screens/AddMoney.dart
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Corrected import
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'dart:js' as js;
import 'dart:js_util' as jsu;

import '../../Dialogs/Sucess.dart';
import 'package:ipay/services/api_service.dart';
import 'package:ipay/providers/auth_provider.dart';
import 'package:ipay/providers/WalletProvider.dart';
import 'package:ipay/providers/AddMoneyProvider.dart';

class AddMoneyToWalletScreen extends StatefulWidget {
  const AddMoneyToWalletScreen({super.key});

  @override
  State<AddMoneyToWalletScreen> createState() => _AddMoneyToWalletScreenState();
}

class _AddMoneyToWalletScreenState extends State<AddMoneyToWalletScreen>
    with TickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  late Razorpay _razorpay; // Declare Razorpay instance

  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay(); // Initialize Razorpay
    _setupRazorpayListeners();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
    _cardAnimationController.forward();

    // Fetch latest balance when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final wallet = Provider.of<IpayWalletProvider>(context, listen: false);
        wallet.refreshBalance(context);
      } catch (_) {}
    });
  }

  void _setupRazorpayListeners() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final auth = Provider.of<PhoneAuthProvider>(context, listen: false);
    final amountText = Provider.of<AddMoneyProvider>(context, listen: false).amountController.text;
    final amount = double.tryParse(amountText) ?? 0.0;

    try {
      final api = ApiService();
      await api.verifyRazorpayPayment(
        token: auth.token!,
        orderId: response.orderId,
        paymentId: response.paymentId,
        signature: response.signature,
        amount: amount,
      );

      SuccessPopup.show(
        context,
        title: 'Money Added',
        message: 'Amount has been added to your wallet.',
        amount: amountText,
        onDone: () {
          Navigator.pop(context);
        },
      );

      final wallet = Provider.of<IpayWalletProvider>(context, listen: false);
      await wallet.refreshBalance(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: $e')),
      );
    } finally {
      _razorpay.clear();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message ?? response.code}')),
    );
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
    _razorpay.clear();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    _razorpay.clear(); // Clear Razorpay instance
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, null); // Remove listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, null);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMoneyProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              IpayColor.primaryColor.withOpacity(0.8),
              IpayColor.primaryColor2,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildWalletCard(context),
                const SizedBox(height: 30),
                _buildAddMoneySection(provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Add Money',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    final wallet = Provider.of<IpayWalletProvider>(context);
    final balanceText = '₹${wallet.balance.toStringAsFixed(2)}';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Current Balance',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (wallet.loading)
              const SizedBox(
                height: 36,
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              )
            else
              Text(
                balanceText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoneySection(AddMoneyProvider provider) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            _buildAmountInput(provider),
            const SizedBox(height: 24),
            _buildQuickAmounts(provider),
            const SizedBox(height: 32),
            _buildAddMoneyButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput(AddMoneyProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: provider.amountController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: const TextStyle(
            color: Color(0xFFA0AEC0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '₹',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          suffixIcon: provider.amountController.text.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.backspace,
                  color: Colors.black45,
                  size: 19,
                ),
                onPressed: () {
                  provider.clearAmount();
                },
              ),
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        onChanged: (value) {
          provider.updateAmountText(value);
        },
      ),
    );
  }

  Widget _buildQuickAmounts(AddMoneyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Select',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: provider.quickAmounts.map((amount) {
            bool isSelected = provider.selectedAmount == amount;
            return GestureDetector(
              onTap: () {
                provider.updateAmountText(amount);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                    colors: [
                      IpayColor.primaryColor,
                      IpayColor.primaryColor2,
                    ],
                  )
                      : null,
                  color: isSelected ? null : const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  '₹$amount',
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF4A5568),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddMoneyButton(AddMoneyProvider provider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            IpayColor.primaryColor2,
            IpayColor.primaryColor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.01),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          final addMoneyProvider = Provider.of<AddMoneyProvider>(
            context,
            listen: false,
          );

          if (addMoneyProvider.amountController.text.isNotEmpty) {
            final amountText = addMoneyProvider.amountController.text;
            final amount = double.tryParse(amountText);
            if (amount == null || amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter valid amount')),
              );
              return;
            }

            try {
              final auth = Provider.of<PhoneAuthProvider>(context, listen: false);
              if (auth.token == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please login again')),
                );
                return;
              }
              final api = ApiService();

              if (kIsWeb) {
                try {
                  final keyResp = await api.getRazorpayPublicKey(token: auth.token);
                  final dynamic keyContainer = keyResp['data'] ?? keyResp;
                  final String? key = (keyContainer is Map) ? (keyContainer['key'] as String?) : null;
                  if (key == null || key.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment is not configured. Try later.')),
                    );
                    return;
                  }

                  final orderResp = await api.createRazorpayOrder(token: auth.token!, amount: amount);
                  final orderId = orderResp['data']?['orderId'] as String?;
                  final orderAmountPaise = orderResp['data']?['amount'];
                  if (orderId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to create order')),
                    );
                    return;
                  }

                  try { jsu.setProperty(js.context, '__RZP_PUBLIC_KEY', key); } catch (_) {}

                  final options = {
                    'key': key,
                    'key_id': key,
                    'amount': orderAmountPaise ?? (amount * 100).round(),
                    'currency': 'INR',
                    'name': 'iPay',
                    'description': 'Wallet top-up',
                    'order_id': orderId,
                    'prefill': {},
                    'theme': {'color': '#3b82f6'},
                  };
                  print('Razorpay options (web): key=${key.substring(0, 8)}..., order=$orderId amount=${orderAmountPaise ?? (amount * 100).round()}');

                  await _openRazorpayWeb(options, onSuccess: (p) async {
                    try {
                      await api.verifyRazorpayPayment(
                        token: auth.token!,
                        orderId: p['order_id'] ?? orderId,
                        paymentId: p['payment_id'] ?? '',
                        signature: p['signature'] ?? '',
                        amount: amount,
                      );
                      SuccessPopup.show(
                        context,
                        title: 'Money Added',
                        message: 'Amount has been added to your wallet.',
                        amount: amountText,
                        onDone: () { Navigator.pop(context); },
                      );
                      final wallet = Provider.of<IpayWalletProvider>(context, listen: false);
                      await wallet.refreshBalance(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verification failed: $e')),
                      );
                    }
                  }, onError: (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment failed: ${e['description'] ?? e['code']}')),
                    );
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unable to start payment: $e')),
                  );
                }
                return;
              }

              final keyResp = await api.getRazorpayPublicKey(token: auth.token!);
              final key = keyResp['data']?['key'] as String?;
              if (key == null || key.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment is not configured. Try later.')),
                );
                return;
              }

              final orderResp = await api.createRazorpayOrder(token: auth.token!, amount: amount);
              final orderId = orderResp['data']?['orderId'] as String?;
              final orderAmountPaise = orderResp['data']?['amount'];
              if (orderId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to create order')),
                );
                return;
              }

              final options = {
                'key': key,
                'amount': orderAmountPaise ?? (amount * 100).round(),
                'currency': 'INR',
                'name': 'iPay',
                'description': 'Wallet top-up',
                'order_id': orderId,
                'prefill': {},
                'theme': {'color': '#3b82f6'},
              };

              _razorpay.open(options);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Unable to start payment: $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter amount')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Add Money',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _openRazorpayWeb(Map<String, dynamic> options, {required Function(Map) onSuccess, required Function(Map) onError}) async {
    try {
      final successWrapper = (dynamic payload) {
        if (payload is Map) {
          onSuccess(Map<String, dynamic>.from(payload));
        } else {
          onSuccess({});
        }
      };
      final errorWrapper = (dynamic payload) {
        if (payload is Map) {
          onError(Map<String, dynamic>.from(payload));
        } else {
          onError({'code': 'UNKNOWN'});
        }
      };
      final jsOptions = jsu.jsify(options);
      js.context.callMethod('openRazorpay', [jsOptions, js.allowInterop(successWrapper), js.allowInterop(errorWrapper)]);
    } catch (e) {
      onError({'code': 'EXCEPTION', 'description': e.toString()});
    }
  }
}
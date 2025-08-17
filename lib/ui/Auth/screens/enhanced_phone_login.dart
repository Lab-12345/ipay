import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_Helper_Function.dart';
import '../../../providers/enhanced_auth_provider.dart';
import '../../common/loading_widget.dart';
import '../../common/feedback_widgets.dart';
import 'enhanced_otp_verification.dart';

class EnhancedPhoneLoginScreen extends StatefulWidget {
  const EnhancedPhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedPhoneLoginScreen> createState() => _EnhancedPhoneLoginScreenState();
}

class _EnhancedPhoneLoginScreenState extends State<EnhancedPhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    // Initialize the auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnhancedAuthProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<EnhancedAuthProvider>(
          builder: (context, authProvider, child) {
            return LoadingOverlay(
              isLoading: authProvider.isLoading,
              loadingMessage: 'Sending OTP...',
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: IpaySize.spaceBtwItems),
                      
                      // Logo
                      IpayHelper.CustomImage(
                        image: 'Ipay!logo.png',
                        height: 100,
                        width: 120,
                      ),
                      
                      const SizedBox(height: IpaySize.spaceBtwItems),
                      
                      // Illustration
                      IpayHelper.CustomImage(
                        image: 'Illustration.png',
                        height: 270,
                        width: null,
                      ),
                      
                      const SizedBox(height: IpaySize.defaultSpace),
                      
                      // Welcome text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IpayHelper.CustomText(
                            text: "Welcome To Ipay",
                            fontSize: 20,
                            color: IpayColor.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                          const SizedBox(height: IpaySize.spaceBtwItemsSm + 2),
                          IpayHelper.CustomText(
                            text: 'Seamless Recharge & Bill payment....',
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: IpaySize.spaceBtwSections),
                      
                      // Phone number input
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: authProvider.errorMessage != null
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg + 5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: IpaySize.borderRadiusLg,
                                vertical: IpaySize.borderRadiusLg,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              child: IpayHelper.CustomText(
                                text: '+91',
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.black54,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: IpaySize.md,
                                    vertical: IpaySize.md,
                                  ),
                                ),
                                validator: (value) => _validatePhoneNumber(value),
                                onChanged: (value) {
                                  // Clear error when user starts typing
                                  if (authProvider.errorMessage != null) {
                                    authProvider.clearError();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Error message
                      if (authProvider.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: IpaySize.defaultSpace),
                      
                      // Terms and conditions checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            activeColor: IpayColor.primaryColor,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agreedToTerms = !_agreedToTerms;
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        color: IpayColor.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: IpayColor.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: IpaySize.defaultSpace),
                      
                      // Continue button
                      LoadingButton(
                        text: "Continue",
                        isLoading: authProvider.isLoading,
                        onPressed: _canProceedToOtp() && _agreedToTerms
                            ? () => _handleContinue(context, authProvider)
                            : null,
                        backgroundColor: IpayColor.primaryColor,
                        height: 50,
                        borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg + 5),
                      ),
                      
                      const SizedBox(height: IpaySize.defaultSpace),
                      
                      // Help section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IpayHelper.CustomText(
                            text: 'Need help?',
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _showHelpDialog(context),
                            child: IpayHelper.CustomText(
                              text: 'Contact Support',
                              fontSize: 15,
                              color: IpayColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: IpaySize.defaultSpace + 5),
                      
                      // Social login divider
                      IpayHelper.CustomText(
                        text: 'Or Sign With',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      
                      const SizedBox(height: IpaySize.defaultSpace - 5),
                      
                      // Social login buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            onTap: () => _handleGoogleSignIn(context),
                            child: Image.asset(
                              'assets/images/google-logo.png',
                              height: IpaySize.defaultSpace,
                            ),
                          ),
                          const SizedBox(width: IpaySize.defaultSpace),
                          _buildSocialButton(
                            onTap: () => _handleFacebookSignIn(context),
                            child: const Icon(
                              Icons.facebook,
                              size: 45,
                              color: IpayColor.primaryColor2,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: IpaySize.spaceBtwSections + 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: child,
      ),
    );
  }

  Future<void> _handleContinue(BuildContext context, EnhancedAuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = _phoneController.text.trim();

      if (phoneNumber.isNotEmpty) {
        // Set phone number in provider and navigate to OTP screen
        authProvider.setPhoneNumber(phoneNumber);

        if (mounted) {
          // Navigate to OTP verification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EnhancedOTPVerificationScreen(),
            ),
          );
        }
      } else {
        FeedbackWidgets.showErrorToast('Please enter a valid phone number');
      }
    } else {
      FeedbackWidgets.showErrorToast('Please enter a valid phone number');
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  bool _canProceedToOtp() {
    final phoneNumber = _phoneController.text.trim();
    return phoneNumber.length == 10 && _agreedToTerms;
  }

  void _handleGoogleSignIn(BuildContext context) {
    FeedbackWidgets.showInfoToast('Google Sign-In coming soon!');
  }

  void _handleFacebookSignIn(BuildContext context) {
    FeedbackWidgets.showInfoToast('Facebook Sign-In coming soon!');
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Need Help?'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact our support team:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, size: 16),
                SizedBox(width: 8),
                Text('support@ipay.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16),
                SizedBox(width: 8),
                Text('+91 1800-123-4567'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 8),
                Text('24/7 Support'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              FeedbackWidgets.showInfoToast('Opening support chat...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: IpayColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Chat Now'),
          ),
        ],
      ),
    );
  }
}
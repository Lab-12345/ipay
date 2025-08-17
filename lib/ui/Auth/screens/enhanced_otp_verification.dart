// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../Hello.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_Helper_Function.dart';
import '../../../providers/enhanced_auth_provider.dart';
import '../../common/loading_widget.dart';
import '../../common/feedback_widgets.dart';
import 'package:ipay/ui/Home/screens/HomeScreen.dart';
// ...existing code...

class EnhancedOTPVerificationScreen extends StatefulWidget {
  const EnhancedOTPVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedOTPVerificationScreen> createState() => _EnhancedOTPVerificationScreenState();
}

class _EnhancedOTPVerificationScreenState extends State<EnhancedOTPVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _clearOtpFields(EnhancedAuthProvider authProvider) {
    for (final c in authProvider.otpControllers) {
      c.clear();
    }
    // move focus to first field
    if (authProvider.otpFocusNodes.isNotEmpty) {
      authProvider.otpFocusNodes.first.requestFocus();
    }
  }

  Future<void> _submitOtpFromFields(EnhancedAuthProvider authProvider) async {
    final otp = authProvider.otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;
    // Try provider method accepting otp string first, otherwise call parameterless verify
    bool success = false;
    try {
      if (authProvider.verifyOtp is Function) {
        final result = await (() async {
          try {
            // prefer verifyOtp(String)
            return await authProvider.verifyOtp(otp);
          } catch (_) {
            // fallback to parameterless verify
            return await authProvider.verifyOtp();
          }
        })();
        success = result == true;
      }
    } catch (e) {
      success = false;
    }

    if (success && mounted) {
      FeedbackWidgets.showSuccessToast('Phone verified successfully!');
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } else {
      // show consistent error and clear fields to allow retry
      FeedbackWidgets.showErrorToast('OTP is incorrect. Please try again.');
      _clearOtpFields(authProvider);
      // play shake animation
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: IpayHelper.CustomText(
          fontSize: 18,
          text: 'OTP Verification',
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Consumer<EnhancedAuthProvider>(
        builder: (context, authProvider, child) {
          return LoadingOverlay(
            isLoading: authProvider!.isLoading,
            loadingMessage: 'Verifying OTP...',
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(IpaySize.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: IpaySize.spaceBtwSections + 5),

                        // Header text
                        IpayHelper.CustomText(
                          text: 'We\'ve sent a verification code to',
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: IpaySize.spaceBtwItemsSm),

                        // Phone number display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: IpayColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            authProvider.phoneNumber ?? '+91XXXXXXXXXX',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: IpaySize.spaceBtwSections + 6),

                        // OTP input fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return _buildOTPField(context, authProvider, index);
                          }),
                        ),

                        // Error message
                        if (authProvider.errorMessage != null) ...[
                          const SizedBox(height: 16),
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

                        // Resend OTP section
                        _buildResendSection(authProvider),

                        const Spacer(),

                        // Verify button
                        LoadingButton(
                          text: 'Verify OTP',
                          isLoading: authProvider.isLoading,
                          onPressed: authProvider.canVerifyOtp()
                              ? () => _handleVerifyOTP(context, authProvider)
                              : null,
                          backgroundColor: IpayColor.primaryColor,
                          height: 50,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        const SizedBox(height: 16),

                        // Help text
                        GestureDetector(
                          onTap: () => _showHelpDialog(context),
                          child: Text(
                            'Didn\'t receive the code? Get help',
                            style: TextStyle(
                              fontSize: 14,
                              color: IpayColor.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, EnhancedAuthProvider authProvider, int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
        border: Border.all(
          color: authProvider.errorMessage != null
              ? Colors.red
              : authProvider.otpControllers[index].text.isNotEmpty
              ? IpayColor.primaryColor
              : Colors.grey.shade300,
          width: authProvider.otpControllers[index].text.isNotEmpty ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: authProvider.otpControllers[index],
        focusNode: authProvider.otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          // clear provider error on input
          authProvider.clearError();

          if (value.isNotEmpty) {
            // move to next field if exists
            if (index + 1 < authProvider.otpFocusNodes.length) {
              authProvider.otpFocusNodes[index + 1].requestFocus();
            } else {
              // last field, attempt auto-submit
              _submitOtpFromFields(authProvider);
            }
          } else {
            // if deleted, move to previous
            if (index - 1 >= 0) {
              authProvider.otpFocusNodes[index - 1].requestFocus();
            }
          }
          setState(() {}); // refresh border colors
        },
      ),
    );
  }

  Widget _buildResendSection(EnhancedAuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: authProvider.canResend ? IpayColor.primaryColor : Colors.grey,
          ),
          const SizedBox(width: 8),
          if (authProvider.canResend)
            GestureDetector(
              onTap: () => _handleResendOTP(context, authProvider),
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  fontSize: 14,
                  color: IpayColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              'Resend OTP in ${authProvider.resendTimer}s',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleVerifyOTP(BuildContext context, EnhancedAuthProvider authProvider) async {
    // explicit verify from button: collect fields and submit
    await _submitOtpFromFields(authProvider);
  }

  Future<void> _handleResendOTP(BuildContext context, EnhancedAuthProvider authProvider) async {
    final success = await authProvider.resendOtp();

    if (success && mounted) {
      FeedbackWidgets.showSuccessToast('OTP sent successfully!');
    } else if (authProvider.errorMessage != null && mounted) {
      FeedbackWidgets.showErrorToast(authProvider.errorMessage!);
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('OTP Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Having trouble with OTP?'),
            SizedBox(height: 16),
            Text('• Check your SMS inbox'),
            Text('• Ensure good network connectivity'),
            Text('• Wait for 30 seconds before requesting new OTP'),
            Text('• Contact support if issue persists'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, size: 16),
                SizedBox(width: 8),
                Text('Support: +91 1800-123-4567'),
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
              FeedbackWidgets.showInfoToast('Contacting support...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: IpayColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}


// ...existing code...
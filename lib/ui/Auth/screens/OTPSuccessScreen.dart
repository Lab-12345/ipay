// File: lib/ui/Auth/screens/otp_success_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/providers/BottomProvider.dart';
import 'package:ipay/ui/Auth/screens/splash.dart';
import 'package:ipay/ui/CommonWidget/BottomNav.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// ✅ Provider for OTP Verification State
class OTPVerificationProvider extends ChangeNotifier {
  bool _isVerified = false;

  bool get isVerified => _isVerified;

  void verifyOTP() {
    _isVerified = true;
    notifyListeners();
  }

  void reset() {
    _isVerified = false;
    notifyListeners();
  }
}

/// ✅ Main OTP Success Screen
class OTPSuccessScreen extends StatefulWidget {
  final String phoneNumber;
  final String token;
  final VoidCallback? onContinue;

  const OTPSuccessScreen({
    super.key,
    required this.phoneNumber,
    required this.token,
    this.onContinue,
  });

  @override
  State<OTPSuccessScreen> createState() => _OTPSuccessScreenState();
}

class _OTPSuccessScreenState extends State<OTPSuccessScreen>
    with TickerProviderStateMixin {

  late AnimationController _checkController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Check mark animation
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );

    // Scale animation for success circle
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    // Fade animation for text content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Slide animation for button
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
  }

  void _startAnimationSequence() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Start scale animation
    await _scaleController.forward();

    // Start check animation with slight delay
    await Future.delayed(const Duration(milliseconds: 100));
    await _checkController.forward();

    // Start fade animation for text
    await Future.delayed(const Duration(milliseconds: 200));
    await _fadeController.forward();

    // Start slide animation for button
    await Future.delayed(const Duration(milliseconds: 300));
    await _slideController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    HapticFeedback.lightImpact();
    if (widget.onContinue != null) {
      widget.onContinue!();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider(
              create: (context) => BottomNavProvider(),
              child: const Bottomnav(),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(IpaySize.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top spacing
              SizedBox(height: size.height * 0.1),

              // Success Animation
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Success Circle with Lottie
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                'assets/animation/Verified.json',
                                repeat: false,
                                animate: true,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: IpaySize.defaultSpace),

                      // Success Text with Fade Animation
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              children: [
                                Text(
                                  'Verification Successful!',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  'Your phone number',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  widget.phoneNumber,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'has been successfully verified',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: IpaySize.defaultSpace * 2),

              // Continue Button with Slide Animation
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SlideTransition(
                      position: _slideAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          child: Text(
                            'Continue to iPay',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Optional: Add a back button
                    SlideTransition(
                      position: _slideAnimation,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Back to Login',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
  }
}

// Custom Painter for Animated Check Mark (if you want to use custom drawing instead of Lottie)
class CheckMarkPainter extends CustomPainter {
  final double animationValue;

  CheckMarkPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Define check mark points
    final startPoint = Offset(size.width * 0.25, size.height * 0.5);
    final middlePoint = Offset(size.width * 0.4, size.height * 0.65);
    final endPoint = Offset(size.width * 0.75, size.height * 0.35);

    if (animationValue <= 0.5) {
      // First part of check mark (start to middle)
      final progress = animationValue / 0.5;
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(
        startPoint.dx + (middlePoint.dx - startPoint.dx) * progress,
        startPoint.dy + (middlePoint.dy - startPoint.dy) * progress,
      );
    } else {
      // Complete first part and animate second part
      final progress = (animationValue - 0.5) / 0.5;
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(middlePoint.dx, middlePoint.dy);
      path.lineTo(
        middlePoint.dx + (endPoint.dx - middlePoint.dx) * progress,
        middlePoint.dy + (endPoint.dy - middlePoint.dy) * progress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckMarkPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Alternative: Success Popup Modal
class OTPSuccessPopup extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onContinue;

  const OTPSuccessPopup({
    super.key,
    required this.phoneNumber,
    this.onContinue,
  });

  static Future<void> show(
      BuildContext context, {
        required String phoneNumber,
        VoidCallback? onContinue,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OTPSuccessPopup(
          phoneNumber: phoneNumber,
          onContinue: onContinue,
        );
      },
    );
  }

  @override
  State<OTPSuccessPopup> createState() => _OTPSuccessPopupState();
}

class _OTPSuccessPopupState extends State<OTPSuccessPopup>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon with Lottie or Custom Icon
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Lottie.asset(
                        'assets/animation/Verified.json',
                        repeat: false,
                        animate: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Success!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Phone number verified successfully',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.phoneNumber,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (widget.onContinue != null) {
                            widget.onContinue!();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Extension for easy navigation
extension OTPSuccessNavigation on BuildContext {
  Future<void> showOTPSuccess({
    required String phoneNumber,
    String? token,
    VoidCallback? onContinue,
    bool useFullScreen = false,
  }) {
    if (useFullScreen) {
      return Navigator.push(
        this,
        MaterialPageRoute(
          builder: (context) => OTPSuccessScreen(
            phoneNumber: phoneNumber,
            token: token ?? '',
            onContinue: onContinue,
          ),
        ),
      );
    } else {
      return OTPSuccessPopup.show(
        this,
        phoneNumber: phoneNumber,
        onContinue: onContinue,
      );
    }
  }
}
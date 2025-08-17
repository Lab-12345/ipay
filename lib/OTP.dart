import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onVerify;
  final VoidCallback? onResendOTP;

  const OTPVerificationScreen({
    Key? key,
    this.phoneNumber = '+91 ',
    this.onVerify,
    this.onResendOTP,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  // Corrected number of controllers to match the 6 OTP fields.
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  // Corrected number of focus nodes to match the 6 OTP fields.
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late AnimationController _pulseController;
  late AnimationController _checkController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _pulseController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {});
  }

  bool get _isOTPComplete {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  String get _otpValue {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 35),

              // Phone Illustration with Animation
              _buildPhoneIllustration(),

              const SizedBox(height: 50),

              // Title
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Enter the OTP sent to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              _buildOTPFields(),

              const SizedBox(height: 30),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't you receive the OTP? ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onResendOTP,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Verify Button
              _buildVerifyButton(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneIllustration() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Pulse Rings
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Transform.scale(
                    scale: 1 + (_pulseController.value * 0.3),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3 * (1 - _pulseController.value)),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Middle ring
                  Transform.scale(
                    scale: 1 + (_pulseController.value * 0.2),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4 * (1 - _pulseController.value)),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Inner ring
                  Transform.scale(
                    scale: 1 + (_pulseController.value * 0.1),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5 * (1 - _pulseController.value)),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Hand holding phone
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8EAF6),
                  Color(0xFFDDD6FE),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Phone body
                Container(
                  width: 50,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Check mark with animation
                AnimatedBuilder(
                  animation: _checkController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_checkController.value * 0.2),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Hand (simplified representation)
          Positioned(
            bottom: 20,
            child: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFDBB5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPFields() {
    // This widget correctly generates 6 fields, so we only need to ensure
    // the controllers and focus nodes match this count.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _controllers[index].text.isEmpty
                  ? Colors.grey.withOpacity(0.3)
                  : const Color(0xFF4285F4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) => _onDigitChanged(value, index),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isOTPComplete
              ? [const Color(0xFF4285F4), const Color(0xFF1976D2)]
              : [Colors.grey.shade300, Colors.grey.shade400],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: _isOTPComplete
            ? [
          BoxShadow(
            color: const Color(0xFF4285F4).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _isOTPComplete
              ? () {
            _checkController.forward();
            if (widget.onVerify != null) {
              widget.onVerify!();
            }
            // Show success message or navigate
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP Verified: ${_otpValue}'),
                backgroundColor: Colors.green,
              ),
            );
          }
              : null,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Verify',
              style: TextStyle(
                color: _isOTPComplete ? Colors.white : Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Usage Example
class OTPDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OTPVerificationScreen(
        phoneNumber: '+91 9879987333',
        onVerify: () {
          print('OTP Verified!');
        },
        onResendOTP: () {
          print('Resending OTP...');
        },
      ),
    );
  }
}
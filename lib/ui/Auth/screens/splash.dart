import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipay/ui/Auth/screens/PhoneLogin.dart';

import '../../../core/constants/app_Helper_Function.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IPayPhoneAuthScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0060ce), Color(0xFF165aba)],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 30,
                child: Column(
                  children: const [

                  ],
                ),
              ),

              // Orbit circles
              Positioned.fill(child: _buildOrbitCircles()),

              // Floating dots
              ..._buildFloatingDots(),

              // Center content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IpayHelper.CustomImage(image: 'Ipay-remove_logo.png', height:null, width: null,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildOrbitCircles() {
    return CustomPaint(painter: OrbitPainter());
  }

  static List<Widget> _buildFloatingDots() {
    return [
      _dot(top: 100, left: 80, size: 9),
      _dot(top: 200, right: 90, size: 12),
      _dot(bottom: 150, left: 100, size: 9),
      _dot(bottom: 80, right: 50, size: 7),
      _dot(top: 320, right: 160, size: 8),
      _dot(top: 720, right: 160, size: 12),
      _dot(top: 220, right: 260, size: 10),
      _dot(top: 620, right: 280, size: 9),
    ];
  }

  static Widget _dot({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double size = 12,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, i * 100, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

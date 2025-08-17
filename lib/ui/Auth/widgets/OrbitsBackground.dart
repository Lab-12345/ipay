import 'package:flutter/material.dart';

class OrbitsBackground extends StatelessWidget {
  const OrbitsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _buildOrbitCircles()),

        ..._buildFloatingDots(),
      ],
    );
  }

  Widget _buildOrbitCircles() {
    return CustomPaint(painter: _OrbitPainter());
  }

  List<Widget> _buildFloatingDots() {
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

  Widget _dot({
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

class _OrbitPainter extends CustomPainter {
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
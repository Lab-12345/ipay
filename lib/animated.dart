import 'package:flutter/material.dart';

class AnimatedIPayLogo extends StatefulWidget {
  final double size;
  final Duration animationDuration;

  const AnimatedIPayLogo({
    Key? key,
    this.size = 200.0,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _AnimatedIPayLogoState createState() => _AnimatedIPayLogoState();
}

class _AnimatedIPayLogoState extends State<AnimatedIPayLogo>
    with TickerProviderStateMixin {
  late AnimationController _barsController;
  late AnimationController _circleController;
  late AnimationController _blinkController;

  late Animation<double> _leftBarAnimation;
  late Animation<double> _centerBarAnimation;
  late Animation<double> _rightBarAnimation;
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _circleOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for vertical bars animation
    _barsController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Controller for circle scaling
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Controller for blinking effect
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Vertical bars animations with different delays
    _leftBarAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _barsController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _centerBarAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _barsController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _rightBarAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _barsController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    // Circle animations
    _circleScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOut,
    ));

    _circleOpacityAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    // Repeat bars animation
    _barsController.repeat(reverse: true);

    // Repeat circle scaling
    _circleController.repeat(reverse: true);

    // Repeat blinking
    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _barsController.dispose();
    _circleController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size * 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Icon
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _barsController,
                _circleController,
                _blinkController,
              ]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: IPayLogoPainter(
                    leftBarHeight: _leftBarAnimation.value,
                    centerBarHeight: _centerBarAnimation.value,
                    rightBarHeight: _rightBarAnimation.value,
                    circleScale: _circleScaleAnimation.value,
                    circleOpacity: _circleOpacityAnimation.value,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Business Name
          Text(
            'I PAY',
            style: TextStyle(
              fontSize: widget.size * 0.15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF6B35),
              letterSpacing: widget.size * 0.02,
            ),
          ),

          const SizedBox(height: 8),

          // Tagline
          Text(
            'SECURE PAYMENTS',
            style: TextStyle(
              fontSize: widget.size * 0.06,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFFFA726),
              letterSpacing: widget.size * 0.01,
            ),
          ),
        ],
      ),
    );
  }
}

class IPayLogoPainter extends CustomPainter {
  final double leftBarHeight;
  final double centerBarHeight;
  final double rightBarHeight;
  final double circleScale;
  final double circleOpacity;

  IPayLogoPainter({
    required this.leftBarHeight,
    required this.centerBarHeight,
    required this.rightBarHeight,
    required this.circleScale,
    required this.circleOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final barWidth = size.width * 0.12;
    final maxBarHeight = size.height * 0.4;
    final barSpacing = size.width * 0.15;

    // Gradient colors
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFA726), // Orange
        Color(0xFFFF6B35), // Red-Orange
      ],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Draw vertical bars
    _drawBar(canvas, gradientPaint,
        center.dx - barSpacing, center.dy,
        barWidth, maxBarHeight * leftBarHeight);

    _drawBar(canvas, gradientPaint,
        center.dx, center.dy + size.height * 0.08,
        barWidth, maxBarHeight * centerBarHeight);

    _drawBar(canvas, gradientPaint,
        center.dx + barSpacing, center.dy,
        barWidth, maxBarHeight * rightBarHeight);

    // Draw animated circle
    final circlePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..color = Color(0xFFFFA726).withOpacity(circleOpacity);

    final circleRadius = (size.width * 0.08) * circleScale;
    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.25),
      circleRadius,
      circlePaint,
    );

    // Draw outer glow for circle
    final glowPaint = Paint()
      ..color = Color(0xFFFFA726).withOpacity(circleOpacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawCircle(
      Offset(center.dx, center.dy - size.height * 0.25),
      circleRadius * 1.5,
      glowPaint,
    );
  }

  void _drawBar(Canvas canvas, Paint paint, double x, double y, double width, double height) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(x, y),
        width: width,
        height: height,
      ),
      Radius.circular(width / 2),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Demo app to show the animated logo
class AnimatedLogoDemo extends StatelessWidget {
  const AnimatedLogoDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('I Pay Animated Logo'),
          backgroundColor: const Color(0xFFFF6B35),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Large logo
                  const AnimatedIPayLogo(
                    size: 200,
                    animationDuration: Duration(milliseconds: 1500),
                  ),
          
                  // Medium logo
                  const AnimatedIPayLogo(
                    size: 150,
                    animationDuration: Duration(milliseconds: 1200),
                  ),
          
                  // Small logo
                  const AnimatedIPayLogo(
                    size: 150,
                    animationDuration: Duration(milliseconds: 1000),
                  ),
          
                  // Usage example
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Perfect for splash screens,\nloading screens, and branding!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
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
  }
}
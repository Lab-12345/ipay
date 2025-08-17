import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Animated I Pay Logo Widget (from previous artifact)
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

    _barsController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _circleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

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

    _startAnimations();
  }

  void _startAnimations() {
    _barsController.repeat(reverse: true);
    _circleController.repeat(reverse: true);
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
          Container(
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

    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFA726),
        Color(0xFFFF6B35),
      ],
    );

    final gradientPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    _drawBar(canvas, gradientPaint,
        center.dx - barSpacing, center.dy,
        barWidth, maxBarHeight * leftBarHeight);

    _drawBar(canvas, gradientPaint,
        center.dx, center.dy + size.height * 0.08,
        barWidth, maxBarHeight * centerBarHeight);

    _drawBar(canvas, gradientPaint,
        center.dx + barSpacing, center.dy,
        barWidth, maxBarHeight * rightBarHeight);

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

// Splash Screen Widget
class IPaySplashScreen extends StatefulWidget {
  final Duration splashDuration;
  final Widget nextScreen;

  const IPaySplashScreen({
    Key? key,
    this.splashDuration = const Duration(seconds: 5),
    required this.nextScreen,
  }) : super(key: key);

  @override
  _IPaySplashScreenState createState() => _IPaySplashScreenState();
}

class _IPaySplashScreenState extends State<IPaySplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _progressController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: widget.splashDuration,
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    // Start fade and scale animations
    _fadeController.forward();
    _scaleController.forward();

    // Start progress animation
    _progressController.forward();

    // Navigate to next screen after splash duration
    await Future.delayed(widget.splashDuration);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E), // Dark blue
              Color(0xFF16213E), // Darker blue
              Color(0xFF0F3460), // Navy blue
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _fadeController,
              _scaleController,
              _progressController,
            ]),
            builder: (context, child) {
              return Column(
                children: [
                  // Top spacing
                  const Spacer(flex: 2),

                  // Animated Logo
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: const AnimatedIPayLogo(
                        size: 250,
                        animationDuration: Duration(milliseconds: 1500),
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Loading Text
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Setting up your secure payment environment',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Progress Bar
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          // Progress Bar
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFA726),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Progress percentage
                          Text(
                            '${(_progressAnimation.value * 100).toInt()}%',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Bottom info
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Powered by Advanced Security',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
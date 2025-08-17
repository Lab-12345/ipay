import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import '../../../core/constants/app_constants.dart';

// Assuming you have this class defined somewhere

class JioCardDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Chose Plan'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Main Jio Card
            JioPrepaidCard(
              phoneNumber: '7099916244',
              userName: 'KAMAL KRISHNA GOSWAMI',
              location: 'Assam',
              onChangePressed: () {
                print('Change button pressed');
              },
              onInfoPressed: () {
                print('Info button pressed');
              },
            ),

            const SizedBox(height: 20),

            // Moved TextField here, outside of JioPrepaidCard
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: IpaySize.md),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600),
                borderRadius: BorderRadius.circular(
                  IpaySize.borderRadiusLg + 5,
                ),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Search enter amount',
                  hintStyle: const TextStyle(
                    fontFamily: 'Ubuntu',
                    color: Colors.black54,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: IpaySize.md,
                    vertical: IpaySize.md,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IpayHelper.CustomText(
                    text: 'Smart Phone',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Popular',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Entertainment',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: '5G Unlimited',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Gaming',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Jio Phone',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Top Up',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 20,),
                  IpayHelper.CustomText(
                    text: 'Jio Bhart',
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Add new connection button
            Container(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  print('Add new connection');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Connection'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[800],
                  side: BorderSide(color: Colors.blue[800]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JioPrepaidCard extends StatefulWidget {
  final String phoneNumber;
  final String userName;
  final String location;
  final VoidCallback onChangePressed;
  final VoidCallback onInfoPressed;
  final bool isCompact;

  const JioPrepaidCard({
    Key? key,
    required this.phoneNumber,
    required this.userName,
    required this.location,
    required this.onChangePressed,
    required this.onInfoPressed,
    this.isCompact = false,
  }) : super(key: key);

  @override
  _JioPrepaidCardState createState() => _JioPrepaidCardState();
}

class _JioPrepaidCardState extends State<JioPrepaidCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              width: double.infinity,
              height: widget.isCompact ? 80 : 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1565C0), // Dark blue
                    Color(0xFF1976D2), // Medium blue
                    Color(0xFF1E88E5), // Light blue
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(_isPressed ? 0.4 : 0.3),
                    blurRadius: _isPressed ? 12 : 8,
                    offset: Offset(0, _isPressed ? 2 : 4),
                    spreadRadius: _isPressed ? 1 : 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Jio Logo
                    Container(
                      width: widget.isCompact ? 40 : 50,
                      height: widget.isCompact ? 40 : 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Jio',
                          style: TextStyle(
                            color: const Color(0xFF1565C0),
                            fontSize: widget.isCompact ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Card Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Phone Number
                          Text(
                            widget.phoneNumber,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isCompact ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (!widget.isCompact) ...[
                            const SizedBox(height: 2),

                            // Jio Prepaid
                            Text(
                              'Jio Prepaid',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 2),

                          // Location
                          Text(
                            widget.location,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: widget.isCompact ? 12 : 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right side buttons
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Change button
                        GestureDetector(
                          onTap: widget.onChangePressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.isCompact ? 11 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Info button
                        if (!widget.isCompact)
                          GestureDetector(
                            onTap: widget.onInfoPressed,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

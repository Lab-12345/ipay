import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LpgScreen extends StatefulWidget {
  const LpgScreen({super.key});

  @override
  State<LpgScreen> createState() => _LpgScreenState();
}

class _LpgScreenState extends State<LpgScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<BillerItem> billers = [
    BillerItem(
      name: 'Bharat Gas (BPCL)',
      logo: 'assets/images/bharat_gas_logo.png',
      category: 'Gas',
      color: const Color(0xFF4285F4),
    ),
    BillerItem(
      name: 'Bharat Gas (BPCL) - Commercial',
      logo: 'assets/images/bharat_gas_logo.png',
      category: 'Gas',
      color: const Color(0xFF34A853),
    ),
    BillerItem(
      name: 'Indane Gas (Indian Oil)',
      logo: 'assets/images/indane_gas_logo.png',
      category: 'Gas',
      color: const Color(0xFFFF6B35),
    ),
  ];

  List<BillerItem> filteredBillers = [];

  @override
  void initState() {
    super.initState();
    filteredBillers = billers;
    _searchController.addListener(_filterBillers);
  }

  void _filterBillers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBillers = billers.where((biller) {
        return biller.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Biller',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4285F4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Bharat\nConnect',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your biller',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Billers List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredBillers.length,
              itemBuilder: (context, index) {
                final biller = filteredBillers[index];
                return BillerCard(
                  biller: biller,
                  onTap: () => _selectBiller(biller),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectBiller(BillerItem biller) {
    _showBillingDialog(context, biller);
  }
}

class BillerCard extends StatelessWidget {
  final BillerItem biller;
  final VoidCallback onTap;

  const BillerCard({
    super.key,
    required this.biller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Logo Container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE3EEFF),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: _buildLogo(biller.name),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Biller Name
                  Expanded(
                    child: Text(
                      biller.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(String billerName) {
    // Since we don't have actual logo assets, we'll create simple icons
    if (billerName.contains('Bharat Gas')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF34A853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'BG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (billerName.contains('Indane')) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'IG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return const Icon(
      Icons.local_gas_station,
      color: Color(0xFF4285F4),
      size: 24,
    );
  }
}

class BillerItem {
  final String name;
  final String logo;
  final String category;
  final Color color; // Add color field

  BillerItem({
    required this.name,
    required this.logo,
    required this.category,
    required this.color, // Correct the constructor
  });
}

// Simple Popup Dialog with Single Input Field
void _showBillingDialog(BuildContext context, BillerItem biller) {
  final TextEditingController customerIdController = TextEditingController();
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: biller.color.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: biller.color.withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDialogHeader(biller),
                            _buildInputSection(customerIdController, biller),
                            _buildActionButtons(
                              context,
                              biller,
                              customerIdController,
                              isLoading,
                                  (loading) => setState(() => isLoading = loading),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildDialogHeader(BillerItem biller) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [biller.color, biller.color.withOpacity(0.8)],
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.local_gas_station_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          biller.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Enter Customer ID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInputSection(TextEditingController controller, BillerItem biller) {
  return Padding(
    padding: const EdgeInsets.all(28),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: biller.color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: biller.color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
          FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
        ],
        decoration: InputDecoration(
          labelText: 'Customer ID / LPG ID',
          labelStyle: TextStyle(
            color: biller.color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [biller.color, biller.color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.credit_card_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          hintText: 'e.g., BG123456789',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
        ),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
          letterSpacing: 1.2,
        ),
      ),
    ),
  );
}

Widget _buildActionButtons(
    BuildContext context,
    BillerItem biller,
    TextEditingController controller,
    bool isLoading,
    Function(bool) setLoading,
    ) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F3F4),
              foregroundColor: const Color(0xFF5F6368),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _processBilling(
              context,
              biller,
              controller.text.trim(),
              setLoading,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: biller.color,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: biller.color.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'Fetch Bill',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Process billing function
void _processBilling(
    BuildContext context,
    BillerItem biller,
    String customerId,
    Function(bool) setLoading,
    ) async {
  if (customerId.isEmpty) {
    _showSnackBar(context, 'Please enter your Customer ID', isError: true);
    return;
  }

  if (customerId.length < 10) {
    _showSnackBar(context, 'Customer ID must be at least 6 characters', isError: true);
    return;
  }

  setLoading(true);

  // Simulate API call
  await Future.delayed(const Duration(seconds: 2));

  setLoading(false);
  Navigator.of(context).pop();

  _showSnackBar(
    context,
    'Bill fetched successfully for ${biller.name}!',
  );
}

void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(
          0xFF38A169),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 3),
    ),
  );
}
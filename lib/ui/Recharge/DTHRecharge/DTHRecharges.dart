import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assuming this is the path to your provider
import '../../../providers/D2HRechargeProvider.dart';
// Assuming this is the path to your DthRechargeInputs screen
import 'DTHRechargeAll.dart';

/// A custom popup function to show a text input dialog.
Future<String?> showTextInputPopup({
  required BuildContext context,
  required String title,
  required Image image,
}) {
  final TextEditingController textController = TextEditingController();

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with image and title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50, width: 50, child: image),
                  const SizedBox(width: 16), // Simplified
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Text input field
              TextField(
                controller: textController,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Subscriber ID',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => textController.clear(),
                    icon: const Icon(Icons.contacts, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Continue button
              ElevatedButton(
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isNotEmpty) {
                    Navigator.of(context).pop(text); // Pass the entered text back
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// The main DTH recharge screen.
class DthRecharges extends StatefulWidget {
  const DthRecharges({super.key});

  @override
  State<DthRecharges> createState() => _DthRechargesState();
}

class _DthRechargesState extends State<DthRecharges> {
  Future<void> _handleTap(String providerName, Image logo) async {
    final subscriberId = await showTextInputPopup(
      context: context,
      title: "$providerName Recharge",
      image: logo,
    );

    if (subscriberId != null && subscriberId.isNotEmpty) {
      // Get the provider instance
      final dthProvider = Provider.of<DthRechargeProvider>(context, listen: false);

      // Call the provider's method to set the state
      dthProvider.setProviderDetails(
        name: providerName,
        image: logo,
        id: subscriberId,
      );

      // FIX: Use the provider's state to pass the required arguments
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DthRechargeInputs(
            subscriberId: dthProvider.subscriberId!,
            providerName: dthProvider.providerName!,
            providerImage: dthProvider.providerImage!,
          ),
        ),
      );
    }
  }

  /// A uniquely designed provider tile.
  Widget _buildProviderTile(String name, Image image) {
    return GestureDetector(
      onTap: () => _handleTap(name, image),
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              SizedBox(height: 50, width: 50, child: image),
              const SizedBox(width: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DTH Recharge'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProviderTile(
                "Tata Sky",
                Image.asset('assets/images/Tataplay.png'),
              ),
              _buildProviderTile(
                "Airtel",
                Image.asset('assets/images/AirtelTv.png'),
              ),
              _buildProviderTile(
                "D2H",
                Image.asset('assets/images/D2HTv.png'),
              ),
              _buildProviderTile(
                "Dish TV",
                Image.asset('assets/images/dishTv.png'),
              ),
              _buildProviderTile(
                "Sun Direct",
                Image.asset('assets/images/SunTv.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
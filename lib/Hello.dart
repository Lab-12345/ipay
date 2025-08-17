import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF5F7FA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bill Payments & Recharges',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Icon(Icons.payment, color: Colors.blue[700], size: 30),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCategory('Popular', [
                      _buildStyledIconText('Mobile Postpaid', Icons.phone, Colors.green),
                      _buildStyledIconText('FastTag Recharge', Icons.local_taxi, Colors.orange),
                      _buildStyledIconText('DTH/TV Recharge', Icons.tv, Colors.red),
                    ]),
                    _buildCategory('Utilities', [
                      _buildStyledIconText('Piped Gas', Icons.local_gas_station, Colors.blue),
                      _buildStyledIconText('LPG Booking', Icons.fire_extinguisher, Colors.red),
                      _buildStyledIconText('Water', Icons.water_drop, Colors.cyan),
                      _buildStyledIconText('Electricity', Icons.lightbulb, Colors.yellow),
                      _buildStyledIconText('Postpaid', Icons.receipt, Colors.grey),
                      _buildStyledIconText('Broadband', Icons.wifi, Colors.teal),
                      _buildStyledIconText('Cable TV', Icons.tv, Colors.purple),
                      _buildStyledIconText('DataCard Prepaid', Icons.signal_wifi_4_bar, Colors.indigo),
                    ]),
                    _buildCategory('Others', [
                      _buildStyledIconText('EMI Payment', Icons.payment, Colors.green),
                      _buildStyledIconText('LIC/Insurance', Icons.shield, Colors.blue),
                      _buildStyledIconText('Municipality', Icons.account_balance, Colors.brown),
                    ]),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Image.asset('assets/bharat_connect_logo.png',), // Add your logo assetheight: 30,
                          const SizedBox(width: 8),
                          const Text(
                            'Powered by Bharat Connect',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
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
        },
      ),
    );
  }

  Widget _buildCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: items,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStyledIconText(String text, IconData icon, Color color) {
    return Container(
      width: 90,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => _showBottomSheet(context),
          child: const Text(
            'Show Bottom Sheet',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
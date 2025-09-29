import 'package:flutter/material.dart';
import 'package:ipay/services/api_service.dart';

class Mobilerecharge extends StatefulWidget {
  const Mobilerecharge({super.key});

  @override
  State<Mobilerecharge> createState() => _MobilerechargeState();
}

class _MobilerechargeState extends State<Mobilerecharge> {
  String mobileNumber = '';
  List<dynamic> operators = [];
  List<dynamic> circles = [];
  String? selectedOperator;
  String? selectedCircle;
  String amount = '';
  List<dynamic> recentRecharges = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchOperators();
    fetchCircles();
  }

  Future<void> fetchOperators() async {
    try {
      final response = await ApiService().getOperators();

      if (response != null && response['success'] == true) {
        setState(() {
          operators = response['data'];
        });
      } else {
        setState(() {
          error = 'Failed to load operators';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching operators: $e';
      });
    }
  }

  Future<void> fetchCircles() async {
    try {
      final response = await ApiService().getCircles();
      if (response != null && response['success'] == true) {
        setState(() {
          circles = response['data'];
        });
      } else {
        setState(() {
          error = response['message'] ?? 'Failed to load circles';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching circles: $e';
      });
    }
  }

  Future<void> _handleRecharge() async {
    if (selectedOperator == null || selectedCircle == null) {
      setState(() {
        error = 'Please select operator and circle';
      });
      return;
    }

    if (mobileNumber.isEmpty || amount.isEmpty) {
      setState(() {
        error = 'Please fill all fields';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await ApiService().performRecharge(
        mobileNumber,
        selectedOperator!,
        selectedCircle!,
        double.tryParse(amount) ?? 0,
      );

      if (response['success']) {
        setState(() {
          recentRecharges.insert(0, response['data']);
          isLoading = false;
          error = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recharge successful')),
        );
      } else {
        setState(() {
          isLoading = false;
          error = response['message'] ?? 'Recharge failed';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error performing recharge: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Recharge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (error != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.red.shade100,
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    mobileNumber = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Operators Dropdown
              DropdownButtonFormField<String>(
                hint: const Text("Select Operator"),
                value: selectedOperator,
                items: operators
                    .where((op) =>
                op['OperatorCode'] != null && op['OperatorName'] != null)
                    .map<DropdownMenuItem<String>>((op) {
                  return DropdownMenuItem<String>(
                    value: op['OperatorCode'] as String,
                    child: Text(op['OperatorName'] as String),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedOperator = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Circles Dropdown
              DropdownButtonFormField<String>(
                hint: const Text("Select Circle"),
                value: selectedCircle,
                items: circles
                    .where((circle) {
                  final code = circle['CircleCode'] ?? circle['id']?.toString();
                  return code != null;
                })
                    .map<DropdownMenuItem<String>>((circle) {
                  final code = circle['CircleCode'] ?? circle['id']?.toString();
                  return DropdownMenuItem<String>(
                    value: code as String,
                    child: Text(circle['CircleName'] ?? circle['name'] ?? 'Unknown Circle'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCircle = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleRecharge,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Recharge'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent Recharges',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentRecharges.length,
                itemBuilder: (context, index) {
                  final recharge = recentRecharges[index];
                  return ListTile(
                    title: Text('Mobile: ${recharge['mobileNumber']}'),
                    subtitle: Text('Amount: ${recharge['amount']}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
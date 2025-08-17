// FiltterDialogs.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';

import '../../../providers/HistoryProvider.dart';

 // Import the provider

class FilterDialog extends StatefulWidget {
  final String selectedPeriod;
  final String selectedStatus;

  const FilterDialog({
    super.key,
    required this.selectedPeriod,
    required this.selectedStatus,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String _tempSelectedPeriod;
  late String _tempSelectedStatus;

  @override
  void initState() {
    super.initState();
    _tempSelectedPeriod = widget.selectedPeriod;
    _tempSelectedStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg),
      ),
      child: Padding(
        padding: EdgeInsets.all(IpaySize.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IpayHelper.CustomText(
              text: 'Filter Transactions',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: IpayColor.blackColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: IpaySize.spaceBtwSections),
            _buildFilterSection('Period', ['This week', 'This month', 'This year'], _tempSelectedPeriod, (value) {
              setState(() {
                _tempSelectedPeriod = value;
              });
            }),
            SizedBox(height: IpaySize.spaceBtwItems),
            _buildFilterSection('Status', ['All', 'Confirmed', 'Pending', 'Failed'], _tempSelectedStatus, (value) {
              setState(() {
                _tempSelectedStatus = value;
              });
            }),
            SizedBox(height: IpaySize.spaceBtwSections),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: IpaySize.spaceBtwItems),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<HistoryProvider>(context, listen: false);
                      provider.updateFilters(_tempSelectedPeriod, _tempSelectedStatus);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String selectedValue, void Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IpayHelper.CustomText(
          text: title,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        SizedBox(height: IpaySize.spaceBtwItems),
        Wrap(
          spacing: IpaySize.sm,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelect(option);
                }
              },
              selectedColor: Colors.blue.shade100,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue.shade900 : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
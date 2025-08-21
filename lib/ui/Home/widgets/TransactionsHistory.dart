import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';

class TransactionsHistory extends StatelessWidget {
  const TransactionsHistory({super.key, required this.recentTransactions});

  final List<Map<String, dynamic>> recentTransactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recentTransactions.map((transaction) {
        return Container(
          margin: EdgeInsets.only(bottom: IpaySize.sm + 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(IpaySize.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
                ),
                child: Center(
                  child: IpayHelper.CustomText(
                    text: transaction['image'],
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(width: IpaySize.spaceBtwItems),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IpayHelper.CustomText(
                      text: transaction['type'],
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    IpayHelper.CustomText(
                      text: transaction['operator'],
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.normal,
                    ),
                    IpayHelper.CustomText(
                      text: transaction['date'],
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction['amount'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: IpaySize.spaceBtwItemsSm/2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        transaction['status'] == 'success'
                            ? Icons.check_circle
                            : Icons.error,
                        size: 16,
                        color: transaction['status'] == 'success'
                            ? IpayColor.successColor
                        //Color(0xFF10B981)
                            : IpayColor.warningColor
                        //Color(0xFFF59E0B),
                      ),
                      SizedBox(width: IpaySize.spaceBtwItemsSm/2),
                      Text(
                        transaction['status'] == 'success'
                            ? 'Success'
                            : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          color: transaction['status'] == 'success'
                              ? IpayColor.successColor
                          //Color(0xFF10B981)
                              : IpayColor.warningColor
                          //Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

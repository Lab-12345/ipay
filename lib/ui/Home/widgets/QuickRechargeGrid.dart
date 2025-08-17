import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';

class QuickRechargeGrid extends StatelessWidget {
  const QuickRechargeGrid({super.key, required this.quickRechargeServices});

  final List<Map<String, dynamic>> quickRechargeServices;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemCount: quickRechargeServices.length,
      itemBuilder: (context, index) {
        final service = quickRechargeServices[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: IpayColor.lightContainerColor,
              borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: IpaySize.borderRadiusMd,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(IpaySize.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: service['colors'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      IpaySize.borderRadiusMd,
                    ),
                  ),
                  width: IpaySize.spaceBtwSections,
                  height: IpaySize.spaceBtwSections,
                  child: Center(
                    child: IpayHelper.CustomText(
                      text: service['image'],
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: IpaySize.spaceBtwItemsSm),
                IpayHelper.CustomText(
                  text: service['name'],
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                IpayHelper.CustomText(
                  text: service['description'],
                  fontSize: 8,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

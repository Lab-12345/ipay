import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';

import '../../../core/constants/app_constants.dart';

class PopularServicesGrid extends StatelessWidget {
  const PopularServicesGrid({super.key, required this.popularServices});

  final List<Map<String, dynamic>> popularServices;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: popularServices.length,
      itemBuilder: (context, index) {
        final service = popularServices[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(IpaySize.sm),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: service['colors'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      IpaySize.borderRadiusMd + 2,
                    ),
                  ),
                  width: 38,
                  height: 38,
                  child: Center(
                    child: IpayHelper.CustomText(
                      text: service['image'],
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: IpaySize.spaceBtwItemsMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IpayHelper.CustomText(
                        text: service['name'],
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      IpayHelper.CustomText(
                        text: service['category'],
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

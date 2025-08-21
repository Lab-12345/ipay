import 'package:flutter/cupertino.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:flutter/gestures.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionText = 'View All',
    this.showActionText = true,
    this.onPressed,
  });

  final String title;
  final String actionText;
  final bool showActionText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IpayHelper.CustomText(
          text: title,
          fontSize: 18,
          color: IpayColor.textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        if (showActionText)
          GestureDetector(
            onTap: onPressed, // Use the onPressed callback here
            child: IpayHelper.CustomText(
              text: actionText,
              fontSize: 14,
              color: IpayColor.primaryColor2,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

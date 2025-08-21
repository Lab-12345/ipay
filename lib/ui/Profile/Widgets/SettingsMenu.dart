import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_color.dart';

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: IpayColor.primaryColor),
      title: IpayHelper.CustomText(
        text: title,
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),
      subtitle: IpayHelper.CustomText(
        text: subTitle,
        fontSize: 13,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

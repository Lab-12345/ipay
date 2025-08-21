import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Home/widgets/SectionHeading.dart';
import 'package:ipay/ui/Profile/Widgets/SettingsMenu.dart';

import '../../core/constants/app_Helper_Function.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IpayColor.primaryBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: IpayColor.primaryColor,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [IpayColor.primaryColor, IpayColor.primaryColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(IpaySize.lg),
                child: Column(
                  children: [
                    /// Header Top
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IpayHelper.CustomText(
                          text: 'Account',
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(height: IpaySize.spaceBtwItems),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          IpaySize.borderRadiusLg,
                        ),
                      ),
                      padding: const EdgeInsets.all(IpaySize.lg),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(
                                IpaySize.borderRadiusMd + 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(IpaySize.sm + 2),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: IpaySize.spaceBtwItems),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IpayHelper.CustomText(
                                  text: 'User Name',
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.normal,
                                ),
                                IpayHelper.CustomText(
                                  text: 'user email.com',
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(IpaySize.md - 4),
                child: Column(
                  children: [
                    SizedBox(height: IpaySize.spaceBtwItems),
                    SectionHeading(title: 'Account Settings', actionText: ''),
                    SizedBox(height: IpaySize.spaceBtwItems),
                    SettingMenu(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy policy',
                      subTitle:
                          'Learn more about our stringent privacy measures and how we\n protect your personal information',
                    ),
                    SettingMenu(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy policy',
                      subTitle:
                          'Learn more about our stringent privacy measures and how we\n protect your personal information',
                    ),
                    SettingMenu(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy policy',
                      subTitle:
                          'Learn more about our stringent privacy measures and how we\n protect your personal information',
                    ),
                    SettingMenu(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy policy',
                      subTitle:
                          'Learn more about our stringent privacy measures and how we\n protect your personal information',
                    ),
                    SettingMenu(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy policy',
                      subTitle:
                          'Learn more about our stringent privacy measures and how we\n protect your personal information',
                    ),
                    SizedBox(height: IpaySize.spaceBtwSections),
                    Padding(
                      padding: const EdgeInsets.only(left: IpaySize.sm,right: IpaySize.sm),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {},
                          child: IpayHelper.CustomText(
                            text: 'Logout',
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

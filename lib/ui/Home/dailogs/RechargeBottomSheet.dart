import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_constants.dart';

import '../../../core/constants/app_Helper_Function.dart';

class RechargeBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const IpayRechargeBottomSheet(),
    );
  }
}

class IpayRechargeBottomSheet extends StatelessWidget {
  const IpayRechargeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(IpaySize.borderRadiusXL),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(context),
          Expanded(child: _buildRechargeGrid(context)),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: IpaySize.sm, bottom: IpaySize.md),
      width: 40,
      height: IpaySize.xs,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(IpaySize.borderRadiusSm - 2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: IpaySize.md,
        vertical: IpaySize.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd),
            ),
            child: const Icon(Icons.payment, color: Colors.white, size: 20),
          ),
          const SizedBox(width: IpaySize.spaceBtwItemsMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IpayHelper.CustomText(
                  text: 'Recharge & Bill Payment',
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                IpayHelper.CustomText(
                  text: 'Choose a service',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeGrid(BuildContext context) {
    final List<RechargeService> services = [
      RechargeService('Mobile Recharge', Icons.phone_android),
      RechargeService('Metro Card', Icons.train),
      RechargeService('DTH Recharge', Icons.tv),
      RechargeService('Data Card', Icons.sim_card),
      RechargeService('Fastag', Icons.speed),
      RechargeService('More Services', Icons.more_horiz),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: IpaySize.md + 4),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: IpaySize.md + 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.9,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return _buildServiceCard(context, services[index]);
        },
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, RechargeService service) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.name} selected'),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF2196F3),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(IpaySize.borderRadiusMd + 3),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(IpaySize.borderRadiusXL),
              ),
              child: Icon(service.icon, color: Colors.white, size: IpaySize.iconMd),
            ),
            const SizedBox(height: IpaySize.defaultSpace / 2),
            IpayHelper.CustomText(
              text: service.name,
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RechargeService {
  final String name;
  final IconData icon;

  RechargeService(this.name, this.icon);
}

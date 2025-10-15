import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_color.dart';
import 'package:ipay/core/constants/app_constants.dart';
import 'package:ipay/ui/Recharge/DTHRecharge/DTHRecharges.dart';
import 'package:ipay/ui/Recharge/MobileRecharge/MobileRecharge.dart';

/// This is the corrected RechargeBottomSheet class that is now a proper Flutter Widget.
class RechargeBottomSheet extends StatelessWidget {
  const RechargeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(IpaySize.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(IpaySize.borderRadiusLg),
          topRight: Radius.circular(IpaySize.borderRadiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(IpaySize.borderRadiusSm),
              ),
            ),
          ),
          const SizedBox(height: IpaySize.spaceBtwSections),

          // Title
          Text(
            'Recharge & Bill Payments',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: IpaySize.spaceBtwItems),

          // Grid of Services
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: IpaySize.md,
            crossAxisSpacing: IpaySize.md,
            children: [
              _buildServiceIcon(
                context,
                icon: Icons.smartphone,
                label: 'Mobile',
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet first
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Mobilerecharge()),
                  );
                },
              ),
              _buildServiceIcon(
                context,
                icon: Icons.satellite_alt,
                label: 'DTH',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DthRecharges()),
                  );
                },
              ),
              _buildServiceIcon(context, icon: Icons.light, label: 'Electricity'),
              _buildServiceIcon(context, icon: Icons.speed, label: 'Fastag'),
              _buildServiceIcon(context, icon: Icons.wifi, label: 'Broadband'),
              _buildServiceIcon(context, icon: Icons.local_gas_station, label: 'Gas Bill'),
              _buildServiceIcon(context, icon: Icons.water_drop, label: 'Water'),
              _buildServiceIcon(context, icon: Icons.phone, label: 'Landline'),
            ],
          ),
          const SizedBox(height: IpaySize.spaceBtwSections),
        ],
      ),
    );
  }

  /// Helper widget to build each icon in the grid.
  Widget _buildServiceIcon(BuildContext context, {required IconData icon, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label coming soon'))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: IpayColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(IpaySize.borderRadiusLg),
            ),
            child: Icon(icon, color: IpayColor.primaryColor, size: 28),
          ),
          const SizedBox(height: IpaySize.spaceBtwItemsSm),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

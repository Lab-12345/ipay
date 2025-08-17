import 'package:flutter/material.dart';
import 'package:ipay/core/constants/app_Helper_Function.dart';
import 'package:ipay/core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: IpayHelper.CustomText(
          text: 'Settings',
          fontSize: 20,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),

              // Profile Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IpayHelper.CustomText(
                            text: "User Name",
                            fontSize: 17,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: IpaySize.spaceBtwItemsSm),
                          IpayHelper.CustomText(
                            text: 'Edit Account',
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ),

              SizedBox(height: IpaySize.spaceBtwSections),

              // Settings Menu Items
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      iconColor: Color(0xFF4A90E2),
                      iconBgColor: Color(0xFF4A90E2).withOpacity(0.1),
                      onTap: () => _handleMenuTap(context, 'Change Password'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      iconColor: Color(0xFFFF8A50),
                      iconBgColor: Color(0xFFFF8A50).withOpacity(0.1),
                      onTap: () => _handleMenuTap(context, 'Notifications'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.people,
                      title: 'Refer Friends & Businesses',
                      iconColor: Color(0xFF50C8FF),
                      iconBgColor: Color(0xFF50C8FF).withOpacity(0.1),
                      onTap: () =>
                          _handleMenuTap(context, 'Refer Friends & Businesses'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.apps,
                      title: 'Third Party Application',
                      iconColor: Color(0xFFE91E63),
                      iconBgColor: Color(0xFFE91E63).withOpacity(0.1),
                      onTap: () =>
                          _handleMenuTap(context, 'Third Party Application'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.help,
                      title: 'FAQ',
                      iconColor: Color(0xFF9C27B0),
                      iconBgColor: Color(0xFF9C27B0).withOpacity(0.1),
                      onTap: () => _handleMenuTap(context, 'FAQ'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.contact_support,
                      title: 'Contact us',
                      iconColor: Color(0xFF4CAF50),
                      iconBgColor: Color(0xFF4CAF50).withOpacity(0.1),
                      onTap: () => _handleMenuTap(context, 'Contact us'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.description,
                      title: 'Terms & Conditions',
                      iconColor: Color(0xFF673AB7),
                      iconBgColor: Color(0xFF673AB7).withOpacity(0.1),
                      onTap: () =>
                          _handleMenuTap(context, 'Terms & Conditions'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      iconColor: Color(0xFFFF5722),
                      iconBgColor: Color(0xFFFF5722).withOpacity(0.1),
                      onTap: () => _showLogoutDialog(context),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.grey[100],
    );
  }

  void _handleMenuTap(BuildContext context, String itemName) {
    print('Tapped: $itemName');
    switch (itemName) {
      case 'Change Password':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
        );
        break;
      case 'Notifications':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationsPage()),
        );
        break;
      case 'Refer Friends & Businesses':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReferFriendsPage()),
        );
        break;
      case 'Third Party Application':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThirdPartyAppPage()),
        );
        break;
      case 'FAQ':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQPage()),
        );
        break;
      case 'Contact us':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUsPage()),
        );
        break;
      case 'Terms & Conditions':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TermsConditionsPage()),
        );
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 300, // Set minimum width
            maxWidth: 350, // Set maximum width
            minHeight: 200, // Set minimum height
            maxHeight: 250, // Set maximum height
          ),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(
              50,
            ), // Increase padding for larger content area
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20), // Add spacing for better visual
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              TextButton(
                onPressed: () {
                  print('User logged out');
                  Navigator.of(context).pop();
                  // Add actual logout logic here (e.g., clear auth token, navigate to login)
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }
}

// Example destination pages (you can create separate files for these)
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFFFF8A50),
      ),
      body: Center(
        child: Text('Notifications Settings', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: Center(
        child: Text('Change Password Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ReferFriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refer Friends & Businesses'),
        backgroundColor: Color(0xFF50C8FF),
      ),
      body: Center(
        child: Text(
          'Refer Friends & Businesses Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ThirdPartyAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Party Application'),
        backgroundColor: Color(0xFFE91E63),
      ),
      body: Center(
        child: Text(
          'Third Party Application Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQ'), backgroundColor: Color(0xFF9C27B0)),
      body: Center(child: Text('FAQ Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: Center(
        child: Text('Contact Us Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: Color(0xFF673AB7),
      ),
      body: Center(
        child: Text('Terms & Conditions Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

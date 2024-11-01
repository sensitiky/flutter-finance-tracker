import 'package:fundora/modelview/themeviewmodel.dart';
import 'package:fundora/modelview/userviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewModel, Themeviewmodel>(
      builder: (context, userViewModel, themeViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade100,
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/300'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userViewModel.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Premium Member',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Stats Card
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeViewModel.isDarkMode
                        ? Colors.white10
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildStatItem(
                        icon: Icons.account_balance_wallet,
                        title: 'Total Balance',
                        value: '\$12,459.50',
                        valueColor: themeViewModel.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                      const Divider(height: 30),
                      _buildStatItem(
                        icon: Icons.trending_up,
                        title: 'Monthly Savings',
                        value: '+\$2,250.00',
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                ),

                // Settings Sections
                _buildSettingsSection(
                  title: 'Account',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      onTap: () {
                        Navigator.pushNamed(context, "/Profile");
                      },
                    ),
                    _buildSettingsItem(
                      icon: Icons.security,
                      title: 'Security',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.credit_card,
                      title: 'Payment Methods',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      onTap: () {},
                    ),
                  ],
                ),

                _buildSettingsSection(
                  title: 'Preferences',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ),
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Language',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      subtitle: 'English',
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      trailing: Consumer<Themeviewmodel>(
                          builder: (context, themeViewModel, chil) {
                        return Switch(
                          value: themeViewModel.isDarkMode,
                          onChanged: (value) {
                            themeViewModel.toggleTheme(value);
                          },
                        );
                      }),
                    ),
                  ],
                ),

                _buildSettingsSection(
                  title: 'Support',
                  items: [
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.policy_outlined,
                      title: 'Privacy Policy',
                      titleColor: themeViewModel.isDarkMode
                          ? Colors.white
                          : Colors.grey[700],
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      titleColor: Colors.red,
                      onTap: () async {
                        await userViewModel.logout();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Consumer<Themeviewmodel>(builder: (context, themeViewModel, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700),
              const SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  color: themeViewModel.isDarkMode
                      ? Colors.white
                      : Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeViewModel.isDarkMode
                        ? Colors.white
                        : Colors.grey[700],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      themeViewModel.isDarkMode ? Colors.white10 : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: items,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? subtitleColor,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(color: subtitleColor),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: Colors.grey[700],
                )
              : null),
    );
  }
}

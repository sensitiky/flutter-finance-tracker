import 'package:fundora/modelview/themeviewmodel.dart';
import 'package:fundora/modelview/userviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewModel, Themeviewmodel>(
      builder: (context, userViewModel, themeViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Manage your profile"),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileItem(
                  colors:
                      themeViewModel.isDarkMode ? Colors.white10 : Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem({Color? colors}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.person),
              Text("Change your username"),
              Icon(Icons.edit),
            ],
          )
        ],
      ),
    );
  }
}

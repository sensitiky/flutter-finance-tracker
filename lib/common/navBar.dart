import 'package:flutter/material.dart';
import 'package:fundora/modelview/themeviewmodel.dart';
import 'package:fundora/view/dashboard/dashboard.dart';
import 'package:fundora/view/home/home.dart';
import 'package:fundora/view/settings/settings.dart';
import 'package:provider/provider.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});
  @override
  HomeNavBarState createState() => HomeNavBarState();
}

class HomeNavBarState extends State<HomeNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToSettings() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(goToSettings: _goToSettings),
      const DashboardScreen(),
      SettingsScreen(),
    ];
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Scaffold(
          body: widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              )
            ],
            currentIndex: _selectedIndex,
            selectedItemColor:
                themeViewModel.isDarkMode ? Colors.blue[700] : Colors.blue[700],
            backgroundColor:
                themeViewModel.isDarkMode ? Colors.white12 : Colors.white,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/modelview/cardviewmodel.dart';
import 'package:expense_tracker/modelview/userviewmodel.dart';
import 'package:expense_tracker/services/cardservices.dart';
import 'package:expense_tracker/services/userservices.dart';
import 'package:expense_tracker/view/dashboard.dart';
import 'package:expense_tracker/view/home.dart';
import 'package:expense_tracker/view/login.dart';
import 'package:expense_tracker/view/register.dart';
import 'package:expense_tracker/view/settings.dart';
import 'package:expense_tracker/view/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(Userservices()),
        ),
        ChangeNotifierProvider(
          create: (context) => CreditCardViewModel(CardServices()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/Welcome",
        home: const Home(),
        routes: {
          "/Home": (context) => const Home(),
          "/Dashboard": (context) => const DashboardScreen(),
          "/Welcome": (context) => const AuthScreen(),
          "/Login": (context) => const LoginForm(),
          "/Register": (context) => const RegisterForm(),
          "/Settings": (context) => SettingsScreen(),
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
      HomeScreen(
        goToSettings: _goToSettings,
      ),
      const DashboardScreen(),
      SettingsScreen(),
    ];
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
        selectedItemColor: Colors.blue.shade700,
        onTap: _onItemTapped,
      ),
    );
  }
}

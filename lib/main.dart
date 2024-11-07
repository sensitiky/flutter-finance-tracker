import 'package:fundora/common/navBar.dart';
import 'package:fundora/firebase_options.dart';
import 'package:fundora/viewmodels/cardviewmodel.dart';
import 'package:fundora/viewmodels/themeviewmodel.dart';
import 'package:fundora/viewmodels/userviewmodel.dart';
import 'package:fundora/services/cardservices.dart';
import 'package:fundora/services/userservices.dart';
import 'package:fundora/view/dashboard/dashboard.dart';
import 'package:fundora/view/auth/login.dart';
import 'package:fundora/view/auth/register.dart';
import 'package:fundora/view/settings/faq.dart';
import 'package:fundora/view/settings/privacypolicy.dart';
import 'package:fundora/view/settings/profile.dart';
import 'package:fundora/view/settings/settings.dart';
import 'package:fundora/view/auth/welcome.dart';
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
            create: (context) => UserViewModel(Userservices())),
        ChangeNotifierProvider(
            create: (context) => CreditCardViewModel(CardServices())),
        ChangeNotifierProvider(create: (context) => Themeviewmodel())
      ],
      child: Consumer<Themeviewmodel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: "/Welcome",
            home: const HomeNavBar(),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.purple,
                brightness: Brightness.light,
              ),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.purple, brightness: Brightness.dark),
            ),
            themeMode:
                themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              "/Home": (context) => const HomeNavBar(),
              "/Dashboard": (context) => const DashboardScreen(),
              "/Welcome": (context) => const AuthScreen(),
              "/Login": (context) => const LoginForm(),
              "/Register": (context) => const RegisterForm(),
              "/Settings": (context) => SettingsScreen(),
              "/Profile": (context) => ProfileScreen(),
              "/Privacy": (context) => PrivacypolicyScreen(),
              "/Faq": (context) => const FAQ()
            },
          );
        },
      ),
    );
  }
}

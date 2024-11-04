import 'package:fundora/view/auth/login.dart';
import 'package:fundora/view/auth/register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your expenses efficiently',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      labelColor: Colors.blue.shade700,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Register'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Expanded(
                  child: TabBarView(
                    children: [
                      LoginForm(),
                      RegisterForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

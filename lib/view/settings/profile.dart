import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundora/modelview/userviewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    nameController.text = userViewModel.name;
    emailController.text = userViewModel.email;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> userData = {};
      if (nameController.text.isNotEmpty) {
        userData['name'] = nameController.text;
      }
      if (emailController.text.isNotEmpty) {
        userData['email'] = emailController.text;
      }

      try {
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        await userViewModel.updateUser(userData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error updating profile: $error")),
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }

      // Update password if fields are filled
      if (passwordController.text.isNotEmpty &&
          passwordController.text == confirmPasswordController.text) {
        try {
          final userViewModel =
              Provider.of<UserViewModel>(context, listen: false);
          await userViewModel.updatePassword(passwordController.text);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password updated successfully")),
            );
          }
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error updating password: $error")),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.shade100,
                                image: const DecorationImage(
                                    image: NetworkImage(
                                        'https://i.pravatar.cc/300'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.camera),
                                      tooltip: "Edit profile picture",
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: nameController,
                          label: "Name",
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: passwordController,
                          label: "New Password",
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: confirmPasswordController,
                          label: "Confirm New Password",
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) {
                            if (passwordController.text.isNotEmpty &&
                                value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: updateProfile,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

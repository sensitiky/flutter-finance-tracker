import 'package:flutter/material.dart';

class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const PrivacyPolicyContent(),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Privacy Policy",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "1. Introduction",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We value your privacy and are committed to protecting your personal data. This privacy policy explains how we handle your data when you use our finance app.",
          ),
          const SizedBox(height: 16),
          const Text(
            "2. Data Collection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We collect personal data that you voluntarily provide to us when you register and use our app. This includes:",
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "- Authentication Data: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "Such as your email address and password used for logging into the app.",
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "- Credit Card Information: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "Including card number, expiration date, cardholder name, and CVV, which you provide when adding a credit card to your account.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "3. Data Usage",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We use your personal data solely for the following purposes:",
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "- Account Management: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "To create and manage your user account.",
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "- Transaction Processing: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "To facilitate transactions using your saved credit cards.",
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "- Customer Support: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "To address your inquiries and provide assistance.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "4. Data Sharing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We do not share your personal data with third parties, except when necessary to comply with legal obligations or to protect our rights. Under no circumstances do we sell or rent your personal data to third parties.",
          ),
          const SizedBox(height: 16),
          const Text(
            "5. Data Security",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We are committed to ensuring that your data is secure. We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction. However, please be aware that no security measures are perfect or impenetrable.",
          ),
          const SizedBox(height: 16),
          const Text(
            "6. Your Rights",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "You have the right to access, correct, or delete your personal data at any time. To exercise these rights, please contact us using the information provided below.",
          ),
          const SizedBox(height: 16),
          const Text(
            "7. Changes to This Privacy Policy",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "We may update this privacy policy from time to time. Any changes will be posted on this page with an updated revision date.",
          ),
          const SizedBox(height: 16),
          const Text(
            "8. Contact Us",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "If you have any questions about this privacy policy, please contact us at support@fundoraapp.com.",
          ),
        ],
      ),
    );
  }
}

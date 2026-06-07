// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../app_components.dart';

class WelcomeScreen extends AbilityScreen {
  const WelcomeScreen() : super('AbilityBridge');

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.all_inclusive, size: 80, color: Colors.blueAccent),
        const SizedBox(height: 20),
        const Text('Empowering Every Ability',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Find inclusive jobs tailored to your abilities.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 40),
        CustomButton(label: 'Get Started', onTap: () => Navigator.pushNamed(context, '/login')),
        CustomButton(
            label: 'Learn About Us',
            primary: false,
            onTap: () => Navigator.pushNamed(context, '/about')),
      ],
    );
  }
}

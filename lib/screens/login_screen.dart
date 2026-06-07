// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../app_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _handleLogin() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email and password'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _loading = true);
    final ok = await AuthService().login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    setState(() => _loading = false);

    if (ok) {
      final prefs = await SharedPreferences.getInstance();
      final role  = prefs.getString('role') ?? 'seeker';
      Navigator.pushReplacementNamed(context, role == 'employer' ? '/employer' : '/seeker');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(height: 20),
            const Icon(Icons.accessibility_new, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text('Welcome Back!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _passwordCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 30),
            _loading
                ? const CircularProgressIndicator()
                : CustomButton(label: 'Login', onTap: _handleLogin),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("Don't have an account? Sign Up")),
          ]),
        ),
      ),
    );
  }
}

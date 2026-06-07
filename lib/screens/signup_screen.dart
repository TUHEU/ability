// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _companyCtrl  = TextEditingController();
  String _role = 'seeker';
  bool   _loading = false;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await AuthService().register(
      _emailCtrl.text.trim(), _passwordCtrl.text.trim(), _role,
      companyName: _role == 'employer' ? _companyCtrl.text.trim() : null,
    );
    setState(() => _loading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please log in.')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create account. Email may already exist.'),
              backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter an email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordCtrl, obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              validator: (v) => v!.length < 6 ? 'Password must be 6+ characters' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'I am a...', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'seeker',   child: Text('Job Seeker')),
                DropdownMenuItem(value: 'employer', child: Text('Employer')),
              ],
              onChanged: (v) => setState(() => _role = v!),
            ),
            if (_role == 'employer') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyCtrl,
                decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Company name is required for employers' : null,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _handleSignup,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Sign Up', style: TextStyle(fontSize: 18)),
            ),
          ]),
        ),
      ),
    );
  }
}

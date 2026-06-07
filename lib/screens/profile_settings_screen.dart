// lib/screens/profile_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _name = 'User', _email = '', _role = 'seeker';
  bool _highContrast = false, _voiceNav = false, _wheelchair = true, _anonymous = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name  = prefs.getString('userName')  ?? 'User';
      _email = prefs.getString('userEmail') ?? '';
      _role  = prefs.getString('role')      ?? 'seeker';
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
          actions: [
            IconButton(icon: const Icon(Icons.report_gmailerrorred),
                onPressed: () => Navigator.pushNamed(context, '/report')),
          ]),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
              child: Column(children: [
                const CircleAvatar(radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 10),
                Text(_name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(_email, style: const TextStyle(color: Colors.grey)),
                Text(_role == 'employer' ? 'Employer Account' : 'Job Seeker',
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
              ]),
            ),
            const Text('Accessibility Needs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _toggle('High Contrast Mode', _highContrast, (v) => setState(() => _highContrast = v)),
            _toggle('Voice Navigation', _voiceNav, (v) => setState(() => _voiceNav = v)),
            _toggle('Wheelchair Access Required', _wheelchair, (v) => setState(() => _wheelchair = v)),
            const Divider(height: 32),
            const Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _toggle('Anonymous Mode', _anonymous, (v) => setState(() => _anonymous = v)),
            const Divider(height: 32),
            const Text('Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _actionBtn('View My Impact Report', Colors.blueAccent,
                () => Navigator.pushNamed(context, '/impact')),
            const SizedBox(height: 10),
            _actionBtn('Logout', Colors.red.shade400, _logout),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _toggle(String title, bool val, ValueChanged<bool> onChanged) {
    return SwitchListTile(
        title: Text(title), value: val, onChanged: onChanged,
        contentPadding: EdgeInsets.zero, activeColor: Colors.blueAccent);
  }

  Widget _actionBtn(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

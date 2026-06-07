// lib/screens/apply_job_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/application_service.dart';

class ApplyJobScreen extends StatefulWidget {
  const ApplyJobScreen({super.key});
  @override State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _coverLetterCtrl = TextEditingController();
  bool    _loading = false;
  late int _jobId;
  String? _jobTitle, _companyName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['jobId'] != null) {
      _jobId       = args['jobId']      as int;
      _jobTitle    = args['jobTitle']   as String?;
      _companyName = args['companyName'] as String?;
    } else {
      Future.microtask(() => Navigator.maybePop(context));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final prefs    = await SharedPreferences.getInstance();
    final seekerId = prefs.getInt('userId') ?? 0;

    if (seekerId == 0) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to apply.'), backgroundColor: Colors.red));
      return;
    }

    final ok = await ApplicationService().applyToJob(_jobId, seekerId);
    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted! 🎉'),
              backgroundColor: Colors.green));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed. You may have already applied.'),
              backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Job')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            if (_jobTitle != null) ...[
              Text(_jobTitle!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('at ${_companyName ?? ''}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 24),
            ],
            const Text(
                'Tell the employer why you\'re a great fit. This is visible only to the hiring team.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coverLetterCtrl, maxLines: 8,
              decoration: const InputDecoration(
                  labelText: 'Cover Letter (Optional)', border: OutlineInputBorder(),
                  alignLabelWithHint: true),
              validator: (v) =>
                  v != null && v.length > 1000 ? 'Too long (max 1000 chars)' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Submit Application',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    );
  }
}

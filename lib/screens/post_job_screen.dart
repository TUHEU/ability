// lib/screens/post_job_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_listing.dart';
import '../services/job_service.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});
  @override State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  String _jobType  = 'full-time';
  bool   _isRemote = false, _loading = false;

  @override void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final prefs     = await SharedPreferences.getInstance();
    final companyId = prefs.getInt('companyId') ?? 0;

    if (companyId == 0) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No company profile found. Contact support.'),
          backgroundColor: Colors.red));
      return;
    }

    final job = JobListing(
      companyId: companyId, title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(), jobType: _jobType, isRemote: _isRemote,
      accommodations: const {'wheelchair': true},
    );

    final ok = await JobService().postJob(job);
    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Job posted successfully! 🎉')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to post job. Please try again.'),
          backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a New Job')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Job Title', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter a job title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl, maxLines: 4,
              decoration: const InputDecoration(
                  labelText: 'Job Description', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter a description' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _jobType,
              decoration: const InputDecoration(labelText: 'Job Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'full-time',  child: Text('Full-Time')),
                DropdownMenuItem(value: 'part-time',  child: Text('Part-Time')),
                DropdownMenuItem(value: 'micro-task', child: Text('Micro-Task')),
              ],
              onChanged: (v) => setState(() => _jobType = v!),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Remote Role'),
              subtitle: const Text('Can this job be done from home?'),
              value: _isRemote,
              onChanged: (v) => setState(() => _isRemote = v),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              child: _loading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Post Job',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    );
  }
}

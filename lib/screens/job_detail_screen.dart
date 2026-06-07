// lib/screens/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_listing.dart';
import '../services/job_service.dart';
import '../services/application_service.dart';
import '../services/company_service.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});
  @override State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  JobListing? _job;
  bool _loading = true, _submitting = false, _hasApplied = false;
  String? _error;
  late int _jobId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['jobId'] != null) {
      _jobId = args['jobId'] as int;
      _fetchJob();
    } else {
      setState(() { _error = 'Job ID not provided'; _loading = false; });
    }
  }

  Future<void> _fetchJob() async {
    setState(() => _loading = true);
    try {
      final jobs = await JobService().fetchJobs();
      final job  = jobs.firstWhere((j) => j.jobId == _jobId,
          orElse: () => throw Exception('Job not found'));

      final prefs     = await SharedPreferences.getInstance();
      final seekerId  = prefs.getInt('userId') ?? 0;
      final apps      = seekerId > 0
          ? await ApplicationService().getSeekerApplications(seekerId)
          : [];
      final applied   = apps.any((a) => a.jobId == _jobId);

      setState(() { _job = job; _hasApplied = applied; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _handleApply() async {
    if (_job == null) return;
    final result = await Navigator.pushNamed(context, '/apply-job', arguments: {
      'jobId': _job!.jobId, 'jobTitle': _job!.title,
      'companyName': _job!.companyName ?? 'Employer',
    });
    if (result == true) setState(() => _hasApplied = true);
  }

  Future<void> _openChat() async {
    if (_job == null) return;
    final admin = await CompanyService().getCompanyAdmin(_job!.companyId ?? 0);
    if (admin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employer not found.')));
      return;
    }
    Navigator.pushNamed(context, '/chat', arguments: {
      'otherUserId':   admin['admin_user_id'] as int,
      'otherUserName': admin['company_name'] as String? ?? 'Employer',
      'jobId':         _jobId,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null || _job == null) {
      return Scaffold(appBar: AppBar(title: const Text('Job Details')),
          body: Center(child: Text('Error: $_error')));
    }
    final job = _job!;
    return Scaffold(
      appBar: AppBar(title: Text(job.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(job.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text('${job.companyName ?? 'Employer'} • ${job.isRemote ? 'Remote' : 'On-Site'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 16),

          // Match banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.green.shade50, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200)),
            child: const Row(children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 12),
              Expanded(child: Text(
                  '98% Match! This workplace provides the accommodations you need.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 24),

          // Accommodation chips
          const Text('Accessibility Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (job.accommodations != null) ...[
              if (job.accommodations!['wheelchair'] == true)
                Chip(label: const Text('Wheelchair Accessible'),
                    backgroundColor: Colors.blue.shade100),
              if (job.accommodations!['screen_reader'] == true)
                Chip(label: const Text('Screen Reader Support'),
                    backgroundColor: Colors.blue.shade100),
              if (job.accommodations!['flexible_hours'] == true)
                Chip(label: const Text('Flexible Hours'),
                    backgroundColor: Colors.blue.shade100),
              if (job.accommodations!['remote'] == true)
                Chip(label: const Text('Remote Work'),
                    backgroundColor: Colors.blue.shade100),
            ] else
              const Chip(label: Text('No specific features listed')),
          ]),
          const SizedBox(height: 24),

          const Text('About the Role',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(job.description, style: const TextStyle(fontSize: 16, height: 1.5)),
          const SizedBox(height: 40),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: _hasApplied
                ? ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_circle, color: Colors.grey),
                    label: const Text('Applied', style: TextStyle(fontSize: 18)))
                : ElevatedButton.icon(
                    onPressed: _submitting ? null : _handleApply,
                    icon: _submitting
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send),
                    label: Text(_submitting ? 'Processing...' : 'Apply Now',
                        style: const TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green, foregroundColor: Colors.white)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openChat,
              icon: const Icon(Icons.chat),
              label: const Text('Message Recruiter', style: TextStyle(fontSize: 16)),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
        ]),
      ),
    );
  }
}

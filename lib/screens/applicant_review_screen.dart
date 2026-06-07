// lib/screens/applicant_review_screen.dart
import 'package:flutter/material.dart';
import '../models/application.dart';
import '../services/application_service.dart';

class ApplicantReviewScreen extends StatefulWidget {
  const ApplicantReviewScreen({super.key});
  @override State<ApplicantReviewScreen> createState() => _ApplicantReviewScreenState();
}

class _ApplicantReviewScreenState extends State<ApplicantReviewScreen> {
  late int _jobId;
  String? _jobTitle;
  List<Application> _apps = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['jobId'] != null) {
      _jobId    = args['jobId']    as int;
      _jobTitle = args['jobTitle'] as String?;
      _fetchApps();
    } else {
      setState(() { _apps = []; _loading = false; });
      Future.microtask(() => Navigator.maybePop(context));
    }
  }

  Future<void> _fetchApps() async {
    setState(() => _loading = true);
    final apps = await ApplicationService().getJobApplications(_jobId);
    setState(() { _apps = apps; _loading = false; });
  }

  Future<void> _updateStatus(int appId, String status) async {
    final ok = await ApplicationService()
        .updateApplicationStatus(applicationId: appId, status: status);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to: $status'),
              backgroundColor: Colors.green));
      _fetchApps();
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':          return Colors.green;
      case 'rejected':          return Colors.red;
      case 'interview_offered':
      case 'interview_scheduled': return Colors.blue;
      case 'viewed':            return Colors.orange;
      default:                  return Colors.grey;
    }
  }

  String _statusLabel(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':            return 'Accepted';
      case 'rejected':            return 'Rejected';
      case 'interview_offered':   return 'Interview Offered';
      case 'interview_scheduled': return 'Interview Scheduled';
      case 'viewed':              return 'Viewed';
      default:                    return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${_jobTitle ?? 'Applicants'} • ${_apps.length} Total')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _apps.isEmpty
              ? const Center(child: Text('No applications yet for this job.'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: _apps.map(_applicantTile).toList(),
                ),
    );
  }

  Widget _applicantTile(Application app) {
    final status = app.status.toLowerCase().trim();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, color: Colors.grey)),
        title: Text(app.seekerName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_statusLabel(status),
            style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (app.seekerBio != null) ...[
                const Text('About Seeker', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(app.seekerBio!),
                const SizedBox(height: 12),
              ],
              if (app.coverLetter != null) ...[
                const Text('Cover Letter', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(app.coverLetter!),
                const SizedBox(height: 12),
              ],
              Text('Applied: ${app.appliedAt.toLocal().toString().substring(0, 16)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/chat', arguments: {
                      'otherUserId': app.seekerId, 'otherUserName': app.seekerName,
                      'jobId': app.jobId,
                    }),
                    icon: const Icon(Icons.chat), label: const Text('Message'),
                  ),
                  const SizedBox(width: 8),
                  if (status == 'pending') ...[
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus(app.applicationId, 'viewed'),
                      icon: const Icon(Icons.visibility), label: const Text('Mark Viewed'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (status == 'pending' || status == 'viewed') ...[
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus(app.applicationId, 'interview_offered'),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Offer Interview'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus(app.applicationId, 'accepted'),
                      icon: const Icon(Icons.check), label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus(app.applicationId, 'rejected'),
                      icon: const Icon(Icons.close), label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, foregroundColor: Colors.white),
                    ),
                  ] else
                    TextButton.icon(
                      onPressed: () => _updateStatus(app.applicationId, 'pending'),
                      icon: const Icon(Icons.undo), label: const Text('Reset Status'),
                    ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// lib/screens/employer_dashboard.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_listing.dart';
import '../services/job_service.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});
  @override State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  List<JobListing> _jobs = [];
  bool _loading = true;
  int _totalPosts = 0, _totalApps = 0, _interviews = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() => _loading = true);
    try {
      final prefs      = await SharedPreferences.getInstance();
      final employerId = prefs.getInt('employerId') ?? 1;
      final data       = await JobService().fetchEmployerDashboard(employerId);
      final stats      = data['stats'] as Map<String, dynamic>? ?? {};
      setState(() {
        _jobs       = data['jobs'] as List<JobListing>;
        _totalPosts = stats['totalPosts'] as int? ?? 0;
        _totalApps  = stats['totalApps']  as int? ?? 0;
        _interviews = stats['interviews'] as int? ?? 0;
        _loading    = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Portal'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchDashboard),
          IconButton(icon: const Icon(Icons.message),
              onPressed: () => Navigator.pushNamed(context, '/messages')),
          IconButton(icon: const Icon(Icons.account_circle),
              onPressed: () => Navigator.pushNamed(context, '/profile')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Stats bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statCard('Total Posts', _totalPosts, Colors.blueAccent),
                    _statCard('Applicants',  _totalApps,  Colors.green),
                    _statCard('Interviews',  _interviews, Colors.orange),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Your Active Listings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _jobs.isEmpty
                    ? const Center(
                        child: Text('No jobs posted yet.\nTap "Post New Job" to get started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16)))
                    : RefreshIndicator(
                        onRefresh: _fetchDashboard,
                        child: ListView.builder(
                          itemCount: _jobs.length,
                          itemBuilder: (ctx, i) => _jobCard(ctx, _jobs[i]),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/post-job');
                      _fetchDashboard();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Post New Job', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  ),
                ),
              ),
            ]),
    );
  }

  Widget _statCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text('$value',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ]),
    );
  }

  Widget _jobCard(BuildContext ctx, JobListing job) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${job.jobType.toUpperCase()} • ${job.isRemote ? 'Remote' : 'On-Site'}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${job.applicantCount ?? 0} Applicants',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: Colors.blueAccent.shade700)),
            const Text('active', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        onTap: () => Navigator.pushNamed(ctx, '/applicant-review',
            arguments: {'jobId': job.jobId, 'jobTitle': job.title}),
      ),
    );
  }
}

// lib/models/job_listing.dart
import 'dart:convert';

class JobListing {
  final int?    jobId;
  final int?    companyId;
  final String? companyName;
  final String  title;
  final String  description;
  final String  jobType;
  final bool    isRemote;
  final Map<String, dynamic>? accommodations;
  final int?    applicantCount;

  const JobListing({
    this.jobId, this.companyId, this.companyName,
    required this.title, required this.description,
    required this.jobType, required this.isRemote,
    this.accommodations, this.applicantCount,
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? acc;
    final raw = json['accommodations'] ?? json['accommodation_offerings'];
    if (raw is Map)    acc = Map<String, dynamic>.from(raw);
    if (raw is String) { try { acc = jsonDecode(raw) as Map<String, dynamic>; } catch (_) {} }

    return JobListing(
      jobId:          json['job_id'] as int?,
      companyId:      json['company_id'] as int? ?? json['employer_id'] as int? ?? 0,
      companyName:    json['company_name'] as String? ?? 'Unknown Company',
      title:          json['title'] as String? ?? 'No Title',
      description:    json['description'] as String? ?? '',
      jobType:        json['job_type'] as String? ?? 'full-time',
      isRemote:       json['is_remote'] == 1 || json['is_remote'] == true,
      accommodations: acc,
      applicantCount: json['applicantCount'] as int? ?? json['applicant_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'company_id': companyId, 'title': title, 'description': description,
    'job_type': jobType, 'is_remote': isRemote,
    'accommodation_offerings': accommodations,
  };
}

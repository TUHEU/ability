// lib/models/application.dart
class Application {
  final int      applicationId;
  final int      jobId;
  final int      seekerId;
  final String   seekerName;
  final String   jobTitle;
  final String   companyName;
  final String?  coverLetter;
  final String   status;
  final DateTime appliedAt;
  final String?  seekerBio;

  const Application({
    required this.applicationId, required this.jobId, required this.seekerId,
    required this.seekerName,    required this.jobTitle, required this.companyName,
    this.coverLetter, required this.status, required this.appliedAt, this.seekerBio,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    applicationId: json['application_id'] as int,
    jobId:         json['job_id'] as int,
    seekerId:      json['seeker_id'] as int? ?? json['seeker_user_id'] as int,
    seekerName:    json['seeker_name'] as String? ?? 'Anonymous',
    jobTitle:      json['job_title'] as String,
    companyName:   json['company_name'] as String? ?? 'Unknown',
    coverLetter:   json['cover_letter'] as String?,
    status:        json['status'] as String,
    appliedAt:     DateTime.parse(json['applied_at'] as String),
    seekerBio:     json['bio'] as String?,
  );
}

// lib/models/seeker_profile.dart
class SeekerProfile {
  final String name;
  final bool   anonymousMode;
  final Map<String, bool> settings;

  const SeekerProfile({required this.name, this.anonymousMode = true, required this.settings});

  factory SeekerProfile.fromJson(Map<String, dynamic> json) => SeekerProfile(
    name:          json['name'] as String? ?? 'Anonymous',
    anonymousMode: json['anonymous_mode'] == 1 || json['anonymous_mode'] == true,
    settings:      json['settings'] != null ? Map<String, bool>.from(json['settings'] as Map) : {},
  );
}

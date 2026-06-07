// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/seeker_dashboard.dart';
import 'screens/employer_dashboard.dart';
import 'screens/job_detail_screen.dart';
import 'screens/apply_job_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/applicant_review_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/profile_settings_screen.dart';
import 'screens/report_screen.dart';
import 'screens/mentorship_screen.dart';
import 'screens/learning_hub_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/impact_report_screen.dart';

void main() => runApp(const AbilityBridge());

class AbilityBridge extends StatelessWidget {
  const AbilityBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AbilityBridge',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
      ),
      initialRoute: '/',
      routes: {
        '/':                (ctx) => const WelcomeScreen(),
        '/login':           (ctx) => const LoginScreen(),
        '/signup':          (ctx) => const SignupScreen(),
        '/about':           (ctx) => const AboutUsScreen(),
        '/seeker':          (ctx) => const SeekerDashboard(),
        '/employer':        (ctx) => const EmployerDashboard(),
        '/job-detail':      (ctx) => const JobDetailScreen(),
        '/apply-job':       (ctx) => const ApplyJobScreen(),
        '/post-job':        (ctx) => const PostJobScreen(),
        '/applicants':      (ctx) => const ApplicantReviewScreen(),
        '/applicant-review':(ctx) => const ApplicantReviewScreen(),
        '/messages':        (ctx) => const MessagesScreen(),
        '/chat':            (ctx) => const ChatScreen(),
        '/profile':         (ctx) => const ProfileSettingsScreen(),
        '/report':          (ctx) => const ReportScreen(),
        '/mentors':         (ctx) => const MentorshipScreen(),
        '/learning':        (ctx) => const LearningHubScreen(),
        '/forum':           (ctx) => const CommunityForumScreen(),
        '/impact':          (ctx) => const ImpactReportScreen(),
      },
    );
  }
}

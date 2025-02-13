import 'package:flutter/material.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/emergency_contacts.dart';
import '../widgets/profile/health_profile_card.dart';
import '../widgets/profile/preferences_section.dart';
import '../widgets/profile/documents_vault.dart';
import '../widgets/profile/achievement_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 24),
              const ProfileHeader(),
              const SizedBox(height: 16),
              const EmergencyContacts(),
              const SizedBox(height: 16),
              const HealthProfileCard(),
              const SizedBox(height: 16),
              const PreferencesSection(),
              const SizedBox(height: 16),
              const DocumentsVault(),
              const SizedBox(height: 16),
              const AchievementGrid(),
            ],
          ),
        ),
      ),
    );
  }
} 
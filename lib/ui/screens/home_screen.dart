import 'package:flutter/material.dart';
import '../widgets/greeting_header.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/sos_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 32),

              // Emergency SOS Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Emergency Help',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Press and hold for emergency assistance',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      const SOSButton(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildQuickActionCard(
                    context,
                    'Doctor',
                    Icons.medical_services_rounded,
                    AppColors.primary,
                  ),
                  _buildQuickActionCard(
                    context,
                    'Medicine',
                    Icons.medication_rounded,
                    AppColors.secondary,
                  ),
                  _buildQuickActionCard(
                    context,
                    'Family',
                    Icons.favorite_rounded,
                    AppColors.tertiary,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Health Overview
              Text(
                'Health Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    _buildHealthMetric(
                      context,
                      'Blood Pressure',
                      '120/80',
                      Icons.favorite_rounded,
                    ),
                    const Divider(height: 1),
                    _buildHealthMetric(
                      context,
                      'Heart Rate',
                      '72 BPM',
                      Icons.timeline_rounded,
                    ),
                    const Divider(height: 1),
                    _buildHealthMetric(
                      context,
                      'Steps Today',
                      '2,547',
                      Icons.directions_walk_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetric(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

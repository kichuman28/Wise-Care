import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HealthProfileCard extends StatelessWidget {
  const HealthProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildHealthInfo(
              context,
              'Blood Group',
              'O+',
              Icons.bloodtype,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildHealthInfo(
              context,
              'Allergies',
              'Peanuts, Penicillin',
              Icons.warning_rounded,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildHealthInfo(
              context,
              'Medical Conditions',
              'Hypertension, Diabetes',
              Icons.medical_information,
              AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInfo(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
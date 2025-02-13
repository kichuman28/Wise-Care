import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

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
              'Preferences',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildPreferenceItem(
              context,
              'Language',
              'English',
              Icons.language,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildPreferenceItem(
              context,
              'Notifications',
              'Enabled',
              Icons.notifications,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildPreferenceItem(
              context,
              'Text Size',
              'Large',
              Icons.text_fields,
              AppColors.tertiary,
            ),
            const SizedBox(height: 12),
            _buildPreferenceItem(
              context,
              'Voice Assistant',
              'Enabled',
              Icons.mic,
              AppColors.quaternary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
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
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
} 
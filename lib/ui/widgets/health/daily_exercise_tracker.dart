import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DailyExerciseTracker extends StatelessWidget {
  const DailyExerciseTracker({super.key});

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
              'Daily Exercise',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildExerciseMetric(
                  context,
                  Icons.directions_walk,
                  '2,345',
                  'Steps',
                  AppColors.primary,
                ),
                _buildExerciseMetric(
                  context,
                  Icons.timer,
                  '25',
                  'Minutes',
                  AppColors.secondary,
                ),
                _buildExerciseMetric(
                  context,
                  Icons.local_fire_department,
                  '150',
                  'Calories',
                  AppColors.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseMetric(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
} 
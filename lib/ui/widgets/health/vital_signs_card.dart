import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VitalSignsCard extends StatelessWidget {
  const VitalSignsCard({super.key});

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
              'Vital Signs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVitalSign(
                  context,
                  Icons.favorite,
                  '72',
                  'Heart Rate',
                  'bpm',
                  AppColors.secondary,
                ),
                _buildVitalSign(
                  context,
                  Icons.speed,
                  '120/80',
                  'Blood Pressure',
                  'mmHg',
                  AppColors.tertiary,
                ),
                _buildVitalSign(
                  context,
                  Icons.water_drop,
                  '95',
                  'Blood Sugar',
                  'mg/dL',
                  AppColors.quaternary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSign(BuildContext context, IconData icon, String value,
      String label, String unit, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
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
        Text(
          unit,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
} 
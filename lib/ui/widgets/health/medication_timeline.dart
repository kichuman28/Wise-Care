import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MedicationTimeline extends StatelessWidget {
  const MedicationTimeline({super.key});

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
              'Today\'s Medications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMedicationItem(
              context,
              'Blood Pressure Medicine',
              '9:00 AM',
              true,
              AppColors.primary,
            ),
            _buildMedicationItem(
              context,
              'Vitamin D Supplement',
              '2:00 PM',
              false,
              AppColors.secondary,
            ),
            _buildMedicationItem(
              context,
              'Calcium Tablet',
              '8:00 PM',
              false,
              AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(BuildContext context, String name, String time,
      bool taken, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.medication, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            taken ? Icons.check_circle : Icons.circle_outlined,
            color: taken ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }
} 
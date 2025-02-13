import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LocalEventsCard extends StatelessWidget {
  const LocalEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Local Events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Create'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildEventItem(
              context,
              'Morning Yoga Session',
              'Today, 7:00 AM',
              '15 people attending',
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildEventItem(
              context,
              'Book Reading Club',
              'Tomorrow, 4:00 PM',
              '8 people attending',
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildEventItem(
              context,
              'Health Talk: Healthy Diet',
              'Saturday, 11:00 AM',
              '25 people attending',
              AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, String title, String time,
      String attendance, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event, color: color),
          ),
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
                  time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  attendance,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            color: color,
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ActivityGroups extends StatelessWidget {
  const ActivityGroups({super.key});

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
              'Activity Groups',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildGroupItem(
              context,
              'Morning Walkers',
              '15 members',
              'Active now',
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildGroupItem(
              context,
              'Yoga Enthusiasts',
              '28 members',
              '2 online',
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildGroupItem(
              context,
              'Book Club',
              '12 members',
              '5 online',
              AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, String name, String members,
      String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(Icons.group, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  members,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  status,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Join',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HelpExchangeBoard extends StatelessWidget {
  const HelpExchangeBoard({super.key});

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
                  'Help Exchange',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Request Help'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHelpItem(
              context,
              'Need help with grocery shopping',
              'Rajesh Kumar',
              '2 km away',
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              context,
              'Looking for company for evening walk',
              'Priya Sharma',
              '1 km away',
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              context,
              'Need assistance with medicine delivery',
              'Suresh Patel',
              '3 km away',
              AppColors.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, String request, String name,
      String distance, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.person, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Icon(Icons.location_on, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                distance,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Help',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
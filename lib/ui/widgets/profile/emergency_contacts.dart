import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class EmergencyContacts extends StatelessWidget {
  const EmergencyContacts({super.key});

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
                  'Emergency Contacts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context,
              'Amit Kumar',
              'Son',
              '+91 98765 43210',
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              context,
              'Dr. Sharma',
              'Family Doctor',
              '+91 98765 43211',
              AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, String name, String relation,
      String phone, Color color) {
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
            child: Icon(Icons.person, color: color),
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
                  relation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
} 
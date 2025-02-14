import 'package:flutter/material.dart';
import '../../../core/models/health_module_model.dart';

class HealthRecordsList extends StatelessWidget {
  const HealthRecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Recent Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            trailing: TextButton(
              onPressed: () {
                // Navigate to all health records
              },
              child: const Text('View All'),
            ),
          ),
          const Divider(height: 1),
          _buildRecordItem(
            context,
            'Annual Check-up',
            'Dr. Sarah Johnson',
            DateTime.now().subtract(const Duration(days: 5)),
            2,
          ),
          const Divider(height: 1),
          _buildRecordItem(
            context,
            'Blood Test Results',
            'Dr. Michael Chen',
            DateTime.now().subtract(const Duration(days: 10)),
            1,
          ),
          const Divider(height: 1),
          _buildRecordItem(
            context,
            'Cardiology Consultation',
            'Dr. Robert Smith',
            DateTime.now().subtract(const Duration(days: 15)),
            3,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                // Show dialog to add new health record
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Add New Record'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(
    BuildContext context,
    String title,
    String doctor,
    DateTime date,
    int attachments,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(doctor),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.attach_file,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '$attachments attachments',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: () {
          // Navigate to record details
        },
      ),
    );
  }
} 
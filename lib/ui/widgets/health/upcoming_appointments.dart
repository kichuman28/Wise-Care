import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

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
                  'Upcoming Appointments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Book'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAppointmentItem(
              context,
              'Dr. Sharma',
              'Cardiologist',
              'Tomorrow, 10:00 AM',
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildAppointmentItem(
              context,
              'Dr. Patel',
              'General Physician',
              'Next Week, 11:30 AM',
              AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(BuildContext context, String doctorName,
      String specialization, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
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
                  doctorName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  specialization,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
            color: color,
          ),
        ],
      ),
    );
  }
} 
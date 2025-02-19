import 'package:flutter/material.dart';
import '../widgets/health/health_records_list.dart';
import '../widgets/health/sleep_data_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Dashboard',
          style: TextStyle(fontSize: 24), // Larger text for better readability
        ),
        actions: [
          Tooltip(
            message: 'Add new health data',
            child: IconButton(
              icon: const Icon(Icons.add, size: 28), // Larger icon for better touch targets
              onPressed: () {
                // Show modal to add new health data
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Information Card
            const SizedBox(height: 24),

            // Medication Reminders
            _buildSectionHeader(
              context,
              'Medication Reminders',
              Icons.medication,
              onTap: () {
                // Navigate to detailed medication view
              },
            ),
            const SizedBox(height: 8),
            //const MedicationList(), // TODO: Create this widget
            const SizedBox(height: 24),

            // Health Records
            _buildSectionHeader(
              context,
              'Health Records',
              Icons.folder_shared,
              onTap: () {
                // Navigate to detailed health records
              },
            ),

            const SizedBox(height: 24),

            // Appointments
            _buildSectionHeader(
              context,
              'Upcoming Appointments',
              Icons.calendar_today,
              onTap: () {
                // Navigate to appointments view
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (onTap != null) const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }
}

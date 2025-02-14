import 'package:flutter/material.dart';
import '../../../core/models/health_module_model.dart';

class VitalSignsCard extends StatelessWidget {
  const VitalSignsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest Readings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to detailed vital signs history
                  },
                  child: const Text('View History'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildVitalSignCard(
                    context,
                    'Blood Pressure',
                    '120/80',
                    'mmHg',
                    Icons.favorite,
                    Colors.red,
                  ),
                  const SizedBox(width: 12),
                  _buildVitalSignCard(
                    context,
                    'Heart Rate',
                    '72',
                    'BPM',
                    Icons.monitor_heart,
                    Colors.pink,
                  ),
                  const SizedBox(width: 12),
                  _buildVitalSignCard(
                    context,
                    'Temperature',
                    '98.6',
                    '°F',
                    Icons.thermostat,
                    Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildVitalSignCard(
                    context,
                    'Oxygen Level',
                    '98',
                    '%',
                    Icons.air,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Show dialog to record new vital signs
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Record New Reading'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 
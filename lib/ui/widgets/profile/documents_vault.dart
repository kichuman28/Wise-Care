import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DocumentsVault extends StatelessWidget {
  const DocumentsVault({super.key});

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
                  'Documents Vault',
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
            _buildDocumentItem(
              context,
              'Medical Reports',
              '3 files',
              Icons.description,
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildDocumentItem(
              context,
              'Prescriptions',
              '5 files',
              Icons.medical_information,
              AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildDocumentItem(
              context,
              'Insurance Documents',
              '2 files',
              Icons.health_and_safety,
              AppColors.tertiary,
            ),
            const SizedBox(height: 12),
            _buildDocumentItem(
              context,
              'ID Documents',
              '4 files',
              Icons.badge,
              AppColors.quaternary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, String title, String count,
      IconData icon, Color color) {
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
            child: Icon(icon, color: color),
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
                  count,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: color.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
} 
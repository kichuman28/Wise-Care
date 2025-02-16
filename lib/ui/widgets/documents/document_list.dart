import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/document_model.dart';
import '../../../core/providers/document_provider.dart';
import 'package:intl/intl.dart';

class DocumentList extends StatelessWidget {
  final List<UserDocument> documents;

  const DocumentList({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final document = documents[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getCategoryColor(document.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(document.category),
                color: _getCategoryColor(document.category),
              ),
            ),
            title: Text(
              document.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(document.description),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(document.uploadDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.folder,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      document.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('View'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(
                        document.isFavorite ? Icons.star : Icons.star_border,
                        color: document.isFavorite ? Colors.amber : Colors.grey[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(document.isFavorite ? 'Remove Favorite' : 'Add to Favorites'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'view':
                    // Open document viewer
                    break;
                  case 'favorite':
                    await context.read<DocumentProvider>().toggleFavorite(document.id);
                    break;
                  case 'delete':
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Document'),
                        content: const Text(
                          'Are you sure you want to delete this document? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await context.read<DocumentProvider>().deleteDocument(document.id);
                    }
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.medical:
        return Colors.blue;
      case DocumentCategory.pension:
        return Colors.green;
      case DocumentCategory.insurance:
        return Colors.purple;
      case DocumentCategory.identification:
        return Colors.orange;
      case DocumentCategory.prescriptions:
        return Colors.red;
      case DocumentCategory.labReports:
        return Colors.teal;
      case DocumentCategory.other:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.medical:
        return Icons.medical_services;
      case DocumentCategory.pension:
        return Icons.account_balance;
      case DocumentCategory.insurance:
        return Icons.health_and_safety;
      case DocumentCategory.identification:
        return Icons.badge;
      case DocumentCategory.prescriptions:
        return Icons.medication;
      case DocumentCategory.labReports:
        return Icons.science;
      case DocumentCategory.other:
        return Icons.folder;
    }
  }
} 
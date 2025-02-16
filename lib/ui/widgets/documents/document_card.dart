import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/document_model.dart';
import '../../../core/providers/document_provider.dart';
import 'package:intl/intl.dart';

class DocumentCard extends StatelessWidget {
  final UserDocument document;

  const DocumentCard({
    super.key,
    required this.document,
  });

  Future<void> _viewDocument(BuildContext context) async {
    try {
      if (document.fileUrl == null || document.fileUrl!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document URL not available'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final url = Uri.parse(document.fileUrl!);
      print('Attempting to open URL: ${url.toString()}');
      
      if (!await canLaunchUrl(url)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not handle this type of document'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final result = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );

      if (!result && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open document. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error opening document: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening document: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewDocument(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(document.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(document.category),
                      color: _getCategoryColor(document.category),
                      size: 24,
                    ),
                  ),
                  PopupMenuButton<String>(
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
                          await _viewDocument(context);
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
                ],
              ),
              const SizedBox(height: 12),
              Text(
                document.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                document.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(document.uploadDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      document.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/providers/document_provider.dart';
import '../../core/models/document_model.dart';
import '../widgets/documents/document_grid.dart';
import '../widgets/documents/document_list.dart';
import '../widgets/documents/upload_document_dialog.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  bool _isGridView = true;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null && context.mounted) {
      final file = File(result.files.single.path!);
      
      // Show upload dialog
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => UploadDocumentDialog(file: file),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Vault'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search documents...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<DocumentProvider>().searchDocuments(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<DocumentCategory?>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter by category',
                  onSelected: (category) {
                    context.read<DocumentProvider>().filterByCategory(category);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All Documents'),
                    ),
                    ...DocumentCategory.values.map((category) => PopupMenuItem(
                      value: category,
                      child: Text(category.displayName),
                    )),
                  ],
                ),
              ],
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Favorites'),
                  selected: false,
                  onSelected: (selected) {
                    // Filter favorites
                  },
                  avatar: const Icon(Icons.star),
                ),
                const SizedBox(width: 8),
                ...DocumentCategory.values.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.displayName),
                    selected: context.watch<DocumentProvider>().selectedCategory == category,
                    onSelected: (selected) {
                      context.read<DocumentProvider>().filterByCategory(
                        selected ? category : null,
                      );
                    },
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Document List/Grid
          Expanded(
            child: Consumer<DocumentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${provider.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        TextButton(
                          onPressed: provider.clearError,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final documents = provider.filteredDocuments;
                if (documents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No documents found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Upload Document'),
                          onPressed: () => _pickAndUploadDocument(context),
                        ),
                      ],
                    ),
                  );
                }

                return _isGridView
                    ? DocumentGrid(documents: documents)
                    : DocumentList(documents: documents);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickAndUploadDocument(context),
        icon: const Icon(Icons.add),
        label: const Text('Upload'),
      ),
    );
  }
} 
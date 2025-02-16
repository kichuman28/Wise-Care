import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/document_model.dart';
import '../../../core/providers/document_provider.dart';
import 'document_card.dart';

class DocumentGrid extends StatelessWidget {
  final List<UserDocument> documents;

  const DocumentGrid({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return DocumentCard(document: document);
      },
    );
  }
} 
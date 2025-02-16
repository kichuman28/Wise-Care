import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';
import '../services/cloudinary_service.dart';

class DocumentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final String userId;

  List<UserDocument> _documents = [];
  DocumentCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  DocumentProvider({required this.userId}) {
    _initializeDocuments();
  }

  // Getters
  List<UserDocument> get documents => _documents;
  List<UserDocument> get filteredDocuments {
    var filtered = _documents;
    
    if (_selectedCategory != null) {
      filtered = filtered.where((doc) => doc.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doc) =>
          doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doc.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }
    
    return filtered;
  }
  
  DocumentCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize documents stream
  void _initializeDocuments() {
    _firestore
        .collection('documents')
        .where('userId', isEqualTo: userId)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _documents = snapshot.docs
            .map((doc) => UserDocument.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Upload new document
  Future<void> uploadDocument({
    required File file,
    required String title,
    required String description,
    required DocumentCategory category,
    List<String> tags = const [],
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Validate file type
      if (!_cloudinaryService.isValidFileType(file.path)) {
        throw Exception('Invalid file type');
      }

      // Upload to Cloudinary
      final response = await _cloudinaryService.uploadFile(
        file,
        category.toString().split('.').last,
      );

      // Create document in Firestore
      final document = UserDocument(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        title: title,
        description: description,
        fileUrl: response.secureUrl,
        fileName: file.path.split('/').last,
        fileType: _cloudinaryService.getFileType(file.path),
        fileSize: await file.length(),
        category: category,
        uploadDate: DateTime.now(),
        tags: tags,
      );

      await _firestore.collection('documents').add(document.toMap());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Filter documents by category
  void filterByCategory(DocumentCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Search documents
  void searchDocuments(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Toggle favorite
  Future<void> toggleFavorite(String documentId) async {
    try {
      final doc = _documents.firstWhere((doc) => doc.id == documentId);
      await _firestore.collection('documents').doc(documentId).update({
        'isFavorite': !doc.isFavorite,
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete document
  Future<void> deleteDocument(String documentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('documents').doc(documentId).delete();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update document
  Future<void> updateDocument(String documentId, {
    String? title,
    String? description,
    DocumentCategory? category,
    List<String>? tags,
  }) async {
    try {
      final doc = _documents.firstWhere((doc) => doc.id == documentId);
      final updatedDoc = doc.copyWith(
        title: title,
        description: description,
        category: category,
        tags: tags,
      );

      await _firestore.collection('documents').doc(documentId).update(
        updatedDoc.toMap(),
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get documents by category
  List<UserDocument> getDocumentsByCategory(DocumentCategory category) {
    return _documents.where((doc) => doc.category == category).toList();
  }

  // Get favorite documents
  List<UserDocument> get favoriteDocuments {
    return _documents.where((doc) => doc.isFavorite).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _documents.clear();
    _error = null;
    _selectedCategory = null;
    _searchQuery = '';
    super.dispose();
  }
} 
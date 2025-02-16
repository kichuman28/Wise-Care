import 'package:cloud_firestore/cloud_firestore.dart';

enum DocumentCategory {
  medical('Medical Documents'),
  pension('Pension Documents'),
  insurance('Insurance Documents'),
  identification('ID Documents'),
  prescriptions('Prescriptions'),
  labReports('Lab Reports'),
  other('Other Documents');

  final String displayName;
  const DocumentCategory(this.displayName);
}

class UserDocument {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String fileUrl;
  final String fileName;
  final String fileType;
  final int fileSize;
  final DocumentCategory category;
  final DateTime uploadDate;
  final DateTime? lastModified;
  final List<String> tags;
  final bool isFavorite;

  UserDocument({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.category,
    required this.uploadDate,
    this.lastModified,
    this.tags = const [],
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'category': category.toString(),
      'uploadDate': Timestamp.fromDate(uploadDate),
      'lastModified': lastModified != null ? Timestamp.fromDate(lastModified!) : null,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  factory UserDocument.fromMap(Map<String, dynamic> map) {
    return UserDocument(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileName: map['fileName'] ?? '',
      fileType: map['fileType'] ?? '',
      fileSize: map['fileSize']?.toInt() ?? 0,
      category: DocumentCategory.values.firstWhere(
        (e) => e.toString() == map['category'],
        orElse: () => DocumentCategory.other,
      ),
      uploadDate: (map['uploadDate'] as Timestamp).toDate(),
      lastModified: map['lastModified'] != null
          ? (map['lastModified'] as Timestamp).toDate()
          : null,
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  UserDocument copyWith({
    String? title,
    String? description,
    DocumentCategory? category,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return UserDocument(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      fileUrl: fileUrl,
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      category: category ?? this.category,
      uploadDate: uploadDate,
      lastModified: DateTime.now(),
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 
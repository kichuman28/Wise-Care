import 'dart:io';
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:path/path.dart' as path;
import '../config/env.dart';

class CloudinaryService {
  late final CloudinaryPublic cloudinary;

  CloudinaryService() {
    print('Initializing Cloudinary with: ${Env.cloudinaryCloudName} and preset: ${Env.cloudinaryUploadPreset}');
    cloudinary = CloudinaryPublic(
      Env.cloudinaryCloudName,
      Env.cloudinaryUploadPreset,
      cache: false,
    );
  }

  Future<CloudinaryResponse> uploadFile(File file, String folder) async {
    try {
      final fileName = path.basename(file.path);
      final fileType = getFileType(fileName);
      
      if (!isValidFileType(fileName)) {
        throw Exception('Invalid file type. Supported types are: PDF, DOC, DOCX, JPG, JPEG, PNG');
      }

      print('Attempting to upload file: $fileName');
      print('File type: $fileType');
      print('Folder: $folder');
      
      final cloudinaryFile = CloudinaryFile.fromFile(
        file.path,
        folder: folder,
        resourceType: CloudinaryResourceType.Auto,
      );
      
      print('Created CloudinaryFile object');
      final response = await cloudinary.uploadFile(cloudinaryFile);
      print('Upload successful. URL: ${response.secureUrl}');
      return response;
    } catch (e) {
      print('Cloudinary upload error: $e');
      rethrow;
    }
  }

  String getFileType(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.pdf':
        return 'pdf';
      case '.doc':
      case '.docx':
        return 'document';
      case '.jpg':
      case '.jpeg':
      case '.png':
        return 'image';
      default:
        return 'other';
    }
  }

  bool isValidFileType(String fileName) {
    final validExtensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.jpg',
      '.jpeg',
      '.png',
    ];
    return validExtensions.contains(path.extension(fileName).toLowerCase());
  }

  String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
import 'package:flutter/foundation.dart';

class SocialModuleModel extends ChangeNotifier {
  List<CommunityForum> forums = [];
  List<GroupActivity> activities = [];
  List<SupportGroup> supportGroups = [];
  List<FamilyMedia> familyMedia = [];
  List<DailyCheckIn> checkIns = [];

  Future<void> addCheckIn(DailyCheckIn checkIn) async {
    try {
      checkIns.add(checkIn);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding check-in: $e');
      rethrow;
    }
  }
}

class CommunityForum {
  final String id;
  final String title;
  final String description;
  final List<ForumPost> posts;
  final int memberCount;

  CommunityForum({
    required this.id,
    required this.title,
    required this.description,
    required this.posts,
    required this.memberCount,
  });
}

class ForumPost {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  final List<Comment> comments;
  final int likes;

  ForumPost({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.comments,
    required this.likes,
  });
}

class Comment {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
  });
}

class GroupActivity {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final int maxParticipants;
  final List<String> participants;

  GroupActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.maxParticipants,
    required this.participants,
  });
}

class SupportGroup {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> members;
  final List<Meeting> meetings;

  SupportGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.members,
    required this.meetings,
  });
}

class Meeting {
  final String id;
  final DateTime dateTime;
  final String topic;
  final String meetingLink;
  final List<String> attendees;

  Meeting({
    required this.id,
    required this.dateTime,
    required this.topic,
    required this.meetingLink,
    required this.attendees,
  });
}

class FamilyMedia {
  final String id;
  final String userId;
  final String mediaUrl;
  final String caption;
  final DateTime timestamp;
  final MediaType type;
  final List<String> tags;

  FamilyMedia({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.caption,
    required this.timestamp,
    required this.type,
    required this.tags,
  });
}

enum MediaType { photo, video, audio }

class DailyCheckIn {
  final String id;
  final DateTime timestamp;
  final String userId;
  final MoodType mood;
  final String note;
  final List<String> activities;

  DailyCheckIn({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.mood,
    required this.note,
    required this.activities,
  });
}

enum MoodType { excellent, good, neutral, notWell, poor }

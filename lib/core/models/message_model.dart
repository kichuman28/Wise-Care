import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String chatRoomId;
  final DateTime createdAt;
  final String receiverId;
  final String receiverName;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  Message({
    required this.chatRoomId,
    required this.createdAt,
    required this.receiverId,
    required this.receiverName,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      chatRoomId: map['chatRoomId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'createdAt': Timestamp.fromDate(createdAt),
      'receiverId': receiverId,
      'receiverName': receiverName,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

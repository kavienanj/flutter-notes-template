import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final Map<String, DateTime> editHistory;

  const Note(
    this.id,
    this.title,
    this.description,
    this.createdBy,
    this.createdAt,
    this.editHistory,
  );

  bool get hasContent => title.isNotEmpty || description.isNotEmpty;

  static final empty = Note('empty', 'empty', 'empty', 'empty', DateTime(0), {});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['id'],
      json['title'],
      json['description'],
      json['created_by'],
      json['created_at'],
      (json['edit_history'] as Map).map<String, DateTime>(
        (key, value) => MapEntry(key, (value as Timestamp).toDate()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt,
      'edit_history': editHistory.map<String, Timestamp>(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),
    };
  }

  Note copyWith({String? title, String? description, Map<String, DateTime>? editHistory}) {
    return Note(
      id,
      title ?? this.title,
      description ?? this.description,
      createdBy,
      createdAt,
      editHistory ?? this.editHistory,
    );
  }
}

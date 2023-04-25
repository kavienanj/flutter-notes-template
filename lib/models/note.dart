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

  static final empty = Note('empty', 'empty', 'empty', 'empty', DateTime(0), const {});

  DateTime get lastEditedTime {
    if (editHistory.isEmpty) return createdAt;
    var lastEdit = editHistory.entries.first.value;
    for (var entry in editHistory.entries) {
      if (entry.value.isAfter(lastEdit)) {
        lastEdit = entry.value;
      }
    }
    return lastEdit;
  }

  String get lastEditedUser {
    if (editHistory.isEmpty) return createdBy;
    var lastEdit = editHistory.entries.first;
    for (var entry in editHistory.entries) {
      if (entry.value.isAfter(lastEdit.value)) {
        lastEdit = entry;
      }
    }
    return lastEdit.key;
  }

  Map<String, DateTime> get sortedEditHistory {
    final sortedKeys = editHistory.keys.toList(growable: false)
      ..sort((k1, k2) => editHistory[k1]!.compareTo(editHistory[k2]!));
    return {for (var key in sortedKeys) key: editHistory[key]!};
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['id'],
      json['title'],
      json['description'],
      json['created_by'],
      (json['created_at'] as Timestamp).toDate(),
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
      'created_at': Timestamp.fromDate(createdAt),
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

class Note {
  final String id;
  final String title;
  final String description;

  const Note(this.id, this.title, this.description);

  bool get hasContent => title.isNotEmpty || description.isNotEmpty;

  static const empty = Note("empty", "empty", "empty");

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['id'],
      json['title'],
      json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  Note copyWith({String? title, String? description}) {
    return Note(
      id,
      title ?? this.title,
      description ?? this.description,
    );
  }
}

class Note {
  final String id;
  final String title;
  final String description;
  final int index;

  Note(this.id, this.title, this.description, this.index);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['id'],
      json['title'],
      json['description'],
      json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'index': index,
    };
  }

  Note copyWith({String? title, String? description, int? index}) {
    return Note(
      id,
      title ?? this.title,
      description ?? this.description,
      index ?? this.index,
    );
  }
}

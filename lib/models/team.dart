class Team {
  final String id;
  final String name;
  final List<String> membersIds;

  Team(this.id, this.name, this.membersIds);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['id'],
      json['name'],
      (json['members'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'members': membersIds,
    };
  }
}

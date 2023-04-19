class Team {
  final String id;
  final String name;
  final String owner;
  final List<String> members;

  Team(this.id, this.name, this.owner, this.members);

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['id'],
      json['name'],
      json['owner'],
      (json['members'] as List).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'members': members,
    };
  }
}

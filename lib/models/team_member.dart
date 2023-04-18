class TeamMember {
  final String teamId;
  final String userId;
  final bool isAdmin;
  final bool hasEditPermission;

  TeamMember(this.teamId, this.userId, this.isAdmin, this.hasEditPermission);

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      json['id'],
      json['user'],
      json['admin'],
      json['can_edit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin': isAdmin,
      'can_edit': hasEditPermission,
    };
  }
}

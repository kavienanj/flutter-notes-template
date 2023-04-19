class TeamMember {
  final String teamId;
  final String userEmail;
  final bool isAdmin;
  final bool isOwner;
  final bool hasEditPermission;

  TeamMember(
    this.teamId,
    this.userEmail,
    this.isAdmin,
    this.isOwner,
    this.hasEditPermission,
  );

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      json['id'],
      json['user'],
      json['is_admin'],
      json['is_owner'],
      json['can_edit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_admin': isAdmin,
      'is_owner': isOwner,
      'can_edit': hasEditPermission,
    };
  }
}

class Group {
  final String uid;
  final String name;
  final String adminId;
  final List<String> members;

  Group(this.uid, this.name, this.adminId, this.members);

  int get membersCount {
    return members.length;
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    final members =
        (json['members'] as List<dynamic>).map((m) => m.toString()).toList();

    return Group(json['uid'] as String, json['name'] as String,
        json['adminId'] as String, members);
  }
}

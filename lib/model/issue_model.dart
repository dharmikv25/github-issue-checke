class GitIssue {
  final int number;
  final String title;
  final String state;
  final String createdAt;
  final String user;
  final List<String> labels;

  GitIssue({
    required this.number,
    required this.title,
    required this.state,
    required this.createdAt,
    required this.user,
    required this.labels,
  });

  factory GitIssue.fromJson(Map<String, dynamic> json) {
    return GitIssue(
      number: json['number'],
      title: json['title'],
      state: json['state'],
      createdAt: json['created_at'],
      user: json['user']['login'],
      labels: List<String>.from(json['labels'].map((l) => l['name'])),
    );
  }
}

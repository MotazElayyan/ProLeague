class Coach {
  final String name;
  final String team;
  final String picture;

  Coach({required this.name, required this.team, required this.picture});

  factory Coach.fromMap(Map<String, dynamic> map) {
    return Coach(
      name: map['name']?.toString().trim() ?? '',
      team: map['team']?.toString().trim() ?? '',
      picture: map['picture']?.toString().trim() ?? '',
    );
  }
}

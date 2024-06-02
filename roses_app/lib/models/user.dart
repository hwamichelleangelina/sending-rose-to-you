class User {
  final int userid;
  final String name;
  final String username;

  User({required this.userid, required this.name, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json['userid'],
      name: json['name'],
      username: json['username'],
    );
  }
}

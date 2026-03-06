import 'package:edudoro/types/decorations.dart';

class FriendsType {
  FriendsType({
    required this.friend_account_id,
    required this.username,
    required this.daily_score,
    required this.decorations,
    required this.friend_at,
  });

  final String friend_account_id;
  final String username;
  final int daily_score;
  final List<Decorations>? decorations;
  final DateTime friend_at;

  factory FriendsType.fromJson(Map<String, dynamic> json) {
    return FriendsType(
      friend_account_id: json['friend_account_id'] as String,
      username: json['username'] as String,
      daily_score: json['daily_score'] as int,
      decorations: (json['decorations'] as List<dynamic>? ?? [])
          .map((item) => Decorations.fromJson(item))
          .toList(),
      friend_at: DateTime.parse(json['friend_at'] as String),
    );
  }
}

class FriendsRequestType {
  FriendsRequestType({
    required this.requester_id,
    required this.username,
    required this.decorations,
  });

  final String requester_id;
  final String username;
  final List<Decorations>? decorations;

  factory FriendsRequestType.fromJson(Map<String, dynamic> json) {
    print("Parsing friend request JSON: $json");

    return FriendsRequestType(
      requester_id: json['requester_id'] as String,
      username: json['username'] as String,
      decorations: (json['decorations'] as List<dynamic>? ?? [])
          .map((item) => Decorations.fromJson(item))
          .toList(),
    );
  }
}

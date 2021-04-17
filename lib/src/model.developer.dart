import 'dart:convert';

import 'package:equatable/equatable.dart';

/// The model class for a trending developer.
class GithubDeveloperItem extends Equatable {
  final String avatar;
  final String name;
  final String username;
  final String popularRepoName;
  final String popularRepoDescription;

  /// Create an instance for a trending developer.
  GithubDeveloperItem({
    required this.avatar,
    required this.name,
    required this.username,
    required this.popularRepoName,
    required this.popularRepoDescription,
  });

  /// The package offers a JSON utility for all model classes.
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'username': username,
      'popularRepoName': popularRepoName,
      'popularRepoDescription': popularRepoDescription,
    };
  }

  /// The package offers a JSON utility for all model classes.
  factory GithubDeveloperItem.fromJson(Map<String, dynamic> json) {
    return GithubDeveloperItem(
      avatar: json['avatar'],
      name: json['name'],
      username: json['username'],
      popularRepoName: json['popularRepoName'],
      popularRepoDescription: json['popularRepoDescription'],
    );
  }

  /// The package offers a JSON utility for all model classes.
  String toRawJson() => json.encode(toJson());

  /// The package offers a JSON utility for all model classes.
  factory GithubDeveloperItem.fromRawJson(String source) => GithubDeveloperItem.fromJson(json.decode(source));

  /// This is for equatable integration.
  @override
  List<Object?> get props => [
        avatar,
        name,
        username,
        popularRepoName,
        popularRepoDescription,
      ];
}

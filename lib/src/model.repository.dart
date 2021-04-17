import 'dart:convert';

import 'package:equatable/equatable.dart';

/// The model class for trending repo item.
class GithubRepoItem extends Equatable {
  /// Create an instance for a trending repo item.
  GithubRepoItem({
    required this.owner,
    required this.repoName,
    required this.description,
    required this.programmingLanguage,
    this.programmingLanguageColor,
    required this.totalStars,
    required this.starsSince,
    required this.totalForks,
    required this.topContributors,
  });

  /// The username or organization name who owns this repository.
  final String owner;

  /// The name of this repository.
  final String repoName;

  /// The short description of this repository.
  final String description;

  /// The primary programming language of this repository. Some have *unknown* language.
  final String programmingLanguage;

  /// The primary programming language color. Some have *unknown* language or unknown colors..
  final String? programmingLanguageColor;

  /// Total number of stars of this repository.
  final int totalStars;

  /// Number of stars of this repository (either for today, this week or this month).
  final String starsSince;

  /// Total number of forks of this repository.
  final int totalForks;

  /// Github trending page only displays the top 5 contributors. This contains the username or organization name and avatar url.
  final List<GithubUserItem> topContributors;

  /// The package offers a JSON utility for all model classes.
  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'repoName': repoName,
      'description': description,
      'programmingLanguage': programmingLanguage,
      'programmingLanguageColor': programmingLanguageColor,
      'totalStars': totalStars,
      'starsSince': starsSince,
      'totalForks': totalForks,
      'topContributors': topContributors.map((x) => x.toJson()).toList(),
    };
  }

  /// The package offers a JSON utility for all model classes.
  factory GithubRepoItem.fromJson(Map<String, dynamic> json) {
    return GithubRepoItem(
      owner: json['owner'],
      repoName: json['repoName'],
      description: json['description'],
      programmingLanguage: json['programmingLanguage'],
      programmingLanguageColor: json['programmingLanguageColor'],
      totalStars: json['totalStars'],
      starsSince: json['starsSince'],
      totalForks: json['totalForks'],
      topContributors: List<GithubUserItem>.from(
          json['topContributors']?.map((x) => GithubUserItem.fromJson(x))),
    );
  }

  /// The package offers a JSON utility for all model classes.
  String toRawJson() => json.encode(toJson());

  /// The package offers a JSON utility for all model classes.
  factory GithubRepoItem.fromRawJson(String rawJson) =>
      GithubRepoItem.fromJson(json.decode(rawJson));

  /// This is for equatable integration.
  @override
  List<Object?> get props => [
        owner,
        repoName,
        description,
        programmingLanguage,
        programmingLanguageColor,
        totalStars,
        starsSince,
        totalForks,
        topContributors,
      ];
}

/// The contributor or owner for a trending repository.
class GithubUserItem extends Equatable {
  final String name;
  final String avatar;

  /// Create an instance of a contributor or owner for a trending repository.
  GithubUserItem({
    required this.name,
    required this.avatar,
  });

  /// The package offers a JSON utility for all model classes.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
    };
  }

  /// The package offers a JSON utility for all model classes.
  factory GithubUserItem.fromJson(Map<String, dynamic> json) {
    return GithubUserItem(
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  /// The package offers a JSON utility for all model classes.
  String toRawJson() => json.encode(toJson());

  /// The package offers a JSON utility for all model classes.
  factory GithubUserItem.fromRawJson(String rawJson) =>
      GithubUserItem.fromJson(json.decode(rawJson));

  /// This is for equatable integration.
  @override
  List<Object?> get props => [name, avatar];
}

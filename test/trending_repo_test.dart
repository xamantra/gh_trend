import 'package:gh_trend/src/index.dart';
import 'package:test/test.dart';

void main() {
  test('all programming language', () async {
    var result = await ghTrendingRepositories();
    expect(result.isNotEmpty, true);
    for (var item in result) {
      _checkItem(item);
    }
  });

  test('english', () async {
    var result = await ghTrendingRepositories(spokenLanguageCode: 'en');
    expect(result.isNotEmpty, true);
    for (var item in result) {
      _checkItem(item);
    }
  });

  test('non-existent programming language', () async {
    const lang = 'dwodjow';
    var result = await ghTrendingRepositories(programmingLanguage: lang);
    final matchingLanguage = result.where((x) => x.programmingLanguage.toLowerCase() == lang);
    expect(matchingLanguage.isEmpty, true);
  });

  test('html only', () async {
    var result = await ghTrendingRepositories(programmingLanguage: 'html');
    for (var item in result) {
      _checkItem(item, programmingLanguageMustBe: 'html');
    }
  });

  test('monthly', () async {
    var result = await ghTrendingRepositories(dateRange: GhTrendDateRange.thisMonth);
    expect(result.isNotEmpty, true);
    for (var item in result) {
      _checkItem(item, dateRangeMustBe: 'stars this month');
    }
  });

  test('weekly', () async {
    var result = await ghTrendingRepositories(dateRange: GhTrendDateRange.thisWeek);
    expect(result.isNotEmpty, true);
    for (var item in result) {
      _checkItem(item, dateRangeMustBe: 'stars this week');
    }
  });

  test('weekly javascript', () async {
    var result = await ghTrendingRepositories(dateRange: GhTrendDateRange.thisWeek, programmingLanguage: 'javascript');
    expect(result.isNotEmpty, true);
    for (var item in result) {
      _checkItem(item, programmingLanguageMustBe: 'javascript', dateRangeMustBe: 'stars this week');
    }
  });
}

void _checkItem(
  GithubRepoItem item, {
  String programmingLanguageMustBe = '',
  String dateRangeMustBe = 'stars today',
}) {
  try {
    expect(item.owner.isNotEmpty, true);
    expect(item.repoName.isNotEmpty, true);
    if (programmingLanguageMustBe.isNotEmpty) {
      expect(item.programmingLanguage.toLowerCase(), programmingLanguageMustBe.toLowerCase());
    }
    if (item.programmingLanguage.isNotEmpty && item.programmingLanguageColor != null) {
      expect(item.programmingLanguageColor!.isNotEmpty, true);
    }
    expect(item.starsSince.isNotEmpty, true);
    expect(item.starsSince.contains(dateRangeMustBe), true);
    // expect(item.topContributors.isNotEmpty, true); // https://github.com/xamantra/gh_trend/pull/3#issuecomment-882156026
    for (var user in item.topContributors) {
      expect(user.avatar.isNotEmpty, true);
      expect(user.name.isNotEmpty, true);
    }
    expect(item.totalForks > -1, true); // forks can be 0.
    expect(item.totalStars > 0, true);
    _checkItemJson(item);
  } catch (e) {
    print(item.toJson());
    rethrow;
  }
}

void _checkItemJson(GithubRepoItem item) {
  try {
    var json = item.toJson();
    var rawJson = item.toRawJson();

    var fromJson = GithubRepoItem.fromJson(json);
    var fromRawJson = GithubRepoItem.fromRawJson(rawJson);

    /* check object equality */
    expect(fromJson, fromRawJson);
    expect(fromJson.hashCode, fromRawJson.hashCode);
    /* check object equality */

    /* check json equality */
    expect(json, fromRawJson.toJson());
    expect(rawJson, fromJson.toRawJson());
    /* check json equality */

    for (var user in item.topContributors) {
      _checkUserJson(user);
    }
  } catch (e) {
    print(item.toJson());
    rethrow;
  }
}

void _checkUserJson(GithubUserItem user) {
  try {
    var json = user.toJson();
    var rawJson = user.toRawJson();

    var fromJson = GithubUserItem.fromJson(json);
    var fromRawJson = GithubUserItem.fromRawJson(rawJson);

    /* check object equality */
    expect(fromJson, fromRawJson);
    expect(fromJson.hashCode, fromRawJson.hashCode);
    /* check object equality */

    /* check json equality */
    expect(json, fromRawJson.toJson());
    expect(rawJson, fromJson.toRawJson());
    /* check json equality */

  } catch (e) {
    print(user.toJson());
    rethrow;
  }
}

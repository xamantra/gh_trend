import 'package:gh_trend/src/index.dart';
import 'package:test/test.dart';

void main() {
  test('trending developers', () async {
    var result = await ghTrendingDevelopers();
    expect(result.isNotEmpty, true);
    for (var dev in result) {
      _checkDev(dev);
    }
  });

  test('trending developers - html', () async {
    var result = await ghTrendingDevelopers(programmingLanguage: 'html');
    expect(result.isNotEmpty, true);
    for (var dev in result) {
      _checkDev(dev);
    }
  });

  test('trending developers - html - weekly', () async {
    var result = await ghTrendingDevelopers(
        programmingLanguage: 'html', dateRange: GhTrendDateRange.thisWeek);
    expect(result.isNotEmpty, true);
    for (var dev in result) {
      _checkDev(dev);
    }
  });

  test('trending developers - html - monthly', () async {
    var result = await ghTrendingDevelopers(
        programmingLanguage: 'html', dateRange: GhTrendDateRange.thisMonth);
    expect(result.isNotEmpty, true);
    for (var dev in result) {
      _checkDev(dev);
    }
  });
}

void _checkDev(GithubDeveloperItem dev) {
  try {
    expect(dev.avatar.isNotEmpty, true);
    expect(dev.name.isNotEmpty, true);
    expect(dev.username.isNotEmpty, true);
    _checkDevJson(dev);
  } catch (e) {
    print(dev.toJson());
    rethrow;
  }
}

void _checkDevJson(GithubDeveloperItem dev) {
  try {
    var json = dev.toJson();
    var rawJson = dev.toRawJson();

    var fromJson = GithubDeveloperItem.fromJson(json);
    var fromRawJson = GithubDeveloperItem.fromRawJson(rawJson);

    /* check object equality */
    expect(fromJson, fromRawJson);
    expect(fromJson.hashCode, fromRawJson.hashCode);
    /* check object equality */

    /* check json equality */
    expect(json, fromRawJson.toJson());
    expect(rawJson, fromJson.toRawJson());
    /* check json equality */
  } catch (e) {
    print(dev.toJson());
    rethrow;
  }
}

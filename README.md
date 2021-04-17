<p align="center">
<img src="https://i.imgur.com/XUC6E7o.png">
</p>
<p align="center">
<strong>GitHub trending scraper for dart and flutter.</strong>
</p>

<p align="center">
<a href="https://pub.dev/packages/gh_trend">
  <img alt="Pub Version" src="https://img.shields.io/pub/v/gh_trend">
</a>
<a href="https://codecov.io/gh/xamantra/gh_trend">
  <img src="https://codecov.io/gh/xamantra/gh_trend/branch/master/graph/badge.svg" />
</a>
<a href="https://github.com/xamantra/gh_trend/actions/workflows/CI.yaml">
  <img src="https://github.com/xamantra/gh_trend/actions/workflows/CI.yaml/badge.svg" />
</a>
</p>

---

## Trending repositories

```dart
var result = await ghTrendingRepositories();
```
The `ghTrendingRepositories()` method will return a list of `GithubRepoItem`.

It also provides optional parameters like:
```dart
var result = await ghTrendingRepositories(
  spokenLanguageCode: 'en',
  programmingLanguage: 'javascript',
  dateRange: GhTrendDateRange.thisWeek, // or `today` or `thisMonth`.
);
```

---

## Trending developers

```dart
var result = await ghTrendingDevelopers();
```
The `ghTrendingDevelopers()` method will return a list of `GithubDeveloperItem`.

It also provides optional parameters like:
```dart
var result = await ghTrendingRepositories(
  programmingLanguage: 'javascript',
  dateRange: GhTrendDateRange.thisWeek, // or `today` or `thisMonth`.
);
```

---

## Parameters

`spokenLanguageCode` - use the provided **ghSpokenLanguages** map to access all spoken languages. You can use the map *value* for the UI and map *key* for the parameter.

`programmingLanguage` - use the provided **ghProgrammingLanguages** map to access all programming languages.  You can use the map *value* for the UI and map *key* for the parameter.

`dateRange` - use the **GhTrendDateRange** enum to access all possible date range. Call the provided method **ghDateRangeLabel(...)** for displaying the value to the UI.

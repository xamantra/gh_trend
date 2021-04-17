import 'index.dart';

/// Used only internally
String repoTrendPath(
  String base, {
  String spokenLanguageCode = '',
  String programmingLanguage = '',
  GhTrendDateRange dateRange = GhTrendDateRange.today,
}) {
  var path = base;
  var queries = <String>[];
  if (programmingLanguage.isNotEmpty) {
    path = '$path/$programmingLanguage';
  }
  if (spokenLanguageCode.isNotEmpty) {
    queries.add('spoken_language_code=$spokenLanguageCode');
  }
  queries.add('since=${ghDateRangeValue(dateRange)}');
  path = '$path?${queries.join("&")}';
  return path;
}

import 'index.dart';

const _scraper = GithubTrendScraper(
  repoItemSelector: 'div>div>div>article.Box-row',
  nameSelector: 'article> h1> a',
  descriptionSelector: 'article> p',
  programmingLanguageSelector: '<span itemprop="programmingLanguage">',
  totalStarsSelector: 'article> div> a:nth-child(2)',
  starsSinceSelector:
      'article> div.f6.color-text-secondary.mt-2> span.d-inline-block.float-sm-right',
  totalForksSelector:
      'article> div.f6.color-text-secondary.mt-2> a:nth-child(3)',
  topContributorsSelector:
      'article> div.f6.color-text-secondary.mt-2> span:nth-child(4)',
  topContributorItemSelector: 'span> a> img',
  topContributorItemAttr: 'src',
  devItemSelector: 'div>div>div>article.Box-row',
  devAvatarSelector: 'div.mx-3 > a > img',
  devNameSelector: 'div > div > div:nth-child(1) > h1 > a',
  devUsernameSelector: 'div > div > div:nth-child(1) > p > a',
  devPopularRepoNameSelector: 'div > div > div > div > article > h1 > a',
  devPopularRepoDescriptionSelector:
      '<div class="f6 color-text-secondary mt-1">',
);

/// Load trending repositories from GitHub.
///
/// ### Parameters
/// `spokenLanguageCode` - use the provided **ghSpokenLanguages** map to access all spoken languages. You can use the map *value* for the UI and map *key* for the parameter.
///
/// `programmingLanguage` - use the provided **ghProgrammingLanguages** map to access all programming languages.  You can use the map *value* for the UI and map *key* for the parameter.
///
/// `dateRange` - use the **GhTrendDateRange** enum to access all possible date range. Call the provided method **ghDateRangeLabel(...)** for displaying the value to the UI.
Future<List<GithubRepoItem>> ghTrendingRepositories({
  String spokenLanguageCode = '',
  String programmingLanguage = '',
  GhTrendDateRange dateRange = GhTrendDateRange.today,
  Map<String, String> headers = const {},
}) async {
  return _scraper.ghTrendingRepositories(
    spokenLanguageCode: spokenLanguageCode,
    programmingLanguage: programmingLanguage,
    dateRange: dateRange,
    headers: headers,
  );
}

/// Load trending developers from GitHub.
///
/// ### Parameters
/// `programmingLanguage` - use the provided **ghProgrammingLanguages** map to access all programming languages.  You can use the map *value* for the UI and map *key* for the parameter.
///
/// `dateRange` - use the **GhTrendDateRange** enum to access all possible date range. Call the provided method **ghDateRangeLabel(...)** for displaying the value to the UI.
Future<List<GithubDeveloperItem>> ghTrendingDevelopers({
  String programmingLanguage = '',
  GhTrendDateRange dateRange = GhTrendDateRange.today,
  Map<String, String> headers = const {},
}) async {
  return _scraper.copyWith(base: '/developers').ghTrendingDevelopers(
        programmingLanguage: programmingLanguage,
        dateRange: dateRange,
        headers: headers,
      );
}

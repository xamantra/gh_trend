import 'package:html/parser.dart' show parse;

import 'index.dart';

/// The utility class for scraping trending repo or devs.
class GithubTrendScraper {
  const GithubTrendScraper({
    this.base = '',
    required this.repoItemSelector,
    required this.nameSelector,
    required this.descriptionSelector,
    required this.programmingLanguageSelector,
    required this.totalStarsSelector,
    required this.starsSinceSelector,
    required this.totalForksSelector,
    required this.topContributorsSelector,
    required this.topContributorItemSelector,
    required this.topContributorItemAttr,
    required this.devItemSelector,
    required this.devAvatarSelector,
    required this.devNameSelector,
    required this.devUsernameSelector,
    required this.devPopularRepoNameSelector,
    required this.devPopularRepoDescriptionSelector,
  });

  final String base;

  /* Repository css selectors */
  final String repoItemSelector;
  final String nameSelector;
  final String descriptionSelector;
  final String programmingLanguageSelector;
  final String totalStarsSelector;
  final String starsSinceSelector;
  final String totalForksSelector;
  final String topContributorsSelector;
  final String topContributorItemSelector;
  final String topContributorItemAttr;
  /* Repository css selectors */

  /* Developer css selectors */
  final String devItemSelector;
  final String devAvatarSelector;
  final String devNameSelector;
  final String devUsernameSelector;
  final String devPopularRepoNameSelector;
  final String devPopularRepoDescriptionSelector;
  /* Developer css selectors */

  /// Load trending repositories from GitHub.
  ///
  /// ### Parameters
  /// `spokenLanguageCode` - try to call the provided **ghSpokenLanguages** map to access all spoken languages. You can use the map values for your UI and map keys for parameters.
  ///
  /// `programmingLanguage` - try to call the provided **ghProgrammingLanguages** map to access all programming languages.  You can use the map values for your UI and map keys for parameters.
  ///
  /// `dateRange` - use the **GhTrendDateRange** enum to access all possible date range. Call the provided method **ghDateRangeLabel(...)** for displaying the value to the UI.
  Future<List<GithubRepoItem>> ghTrendingRepositories({
    String spokenLanguageCode = '',
    String programmingLanguage = '',
    GhTrendDateRange dateRange = GhTrendDateRange.today,
    Map<String, String> headers = const {},
  }) async {
    var result = <GithubRepoItem>[];
    try {
      print('$logHeader ${ghDateRangeLabel(dateRange)}');
      var response = await request(
        repoTrendPath(
          base,
          spokenLanguageCode: spokenLanguageCode,
          programmingLanguage: programmingLanguage,
          dateRange: dateRange,
        ),
        headers: headers,
      );

      // for some reason, the `html` package can't scrape the programming language without doing this
      var rawHtml = response.body.replaceAll(programmingLanguageSelector, '<span id="programmingLanguage">');
      // but I think it has something to do with the "level 4" limitation of the package.

      var html = parse(rawHtml);
      var htmlItems = html.querySelectorAll(repoItemSelector);
      for (var htmlItem in htmlItems) {
        try {
          var name = htmlItem.querySelector(nameSelector)?.text.trim().split('/') ?? [];
          var owner = '';
          var repoName = '';
          if (name.isNotEmpty) {
            owner = name[0].trim();
            repoName = name[1].trim();
          }

          // another issue and solution for level 4 selectors.
          var from = 'href="/$owner/$repoName/stargazers"';
          var rawItem = htmlItem.outerHtml.replaceAll(from, '$from id="stargazersCount" ');
          var item = parse(rawItem);
          // manipulate to make it easy to select the element and re-parse.

          var description = item.querySelector(descriptionSelector)?.text.trim() ?? '';
          var programmingLanguage = item.querySelector('#programmingLanguage')?.text.trim() ?? '';
          var totalStars = int.parse(item.querySelector('#stargazersCount')?.text.trim().replaceAll(',', '') ?? '0');
          var starsSince = item.querySelector(starsSinceSelector)?.text.trim().replaceAll(',', '') ?? '';
          var totalForks = int.parse(item.querySelector(totalForksSelector)?.text.trim().replaceAll(',', '') ?? '0');
          var topContributors = <GithubUserItem>[];
          var topConributorItems = item.querySelectorAll(topContributorItemSelector);
          for (var contribItem in topConributorItems) {
            try {
              var avatar = contribItem.attributes[topContributorItemAttr] ?? '';
              var name = (contribItem.attributes['alt'] ?? '').replaceAll('@', '');
              topContributors.add(GithubUserItem(name: name, avatar: avatar));
            } catch (e) {
              print(['repo (var contribItem in topConributorItems)', e]);
            }
          }
          result.add(GithubRepoItem(
            owner: owner,
            repoName: repoName,
            description: description,
            programmingLanguage: programmingLanguage,
            totalStars: totalStars,
            starsSince: starsSince,
            totalForks: totalForks,
            topContributors: topContributors,
          ));
        } catch (e) {
          print(['repo (var item in htmlItems)', e]);
        }
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  /// Load trending developers from GitHub.
  ///
  /// ### Parameters
  /// `programmingLanguage` - try to call the provided **ghProgrammingLanguages** map to access all programming languages.  You can use the map values for your UI and map keys for parameters.
  ///
  /// `dateRange` - use the **GhTrendDateRange** enum to access all possible date range. Call the provided method **ghDateRangeLabel(...)** for displaying the value to the UI.
  Future<List<GithubDeveloperItem>> ghTrendingDevelopers({
    String programmingLanguage = '',
    GhTrendDateRange dateRange = GhTrendDateRange.today,
    Map<String, String> headers = const {},
  }) async {
    var result = <GithubDeveloperItem>[];
    try {
      print('$logHeader $base ${ghDateRangeLabel(dateRange)}');
      var response = await request(
        repoTrendPath(
          base,
          programmingLanguage: programmingLanguage,
          dateRange: dateRange,
        ),
        headers: headers,
      );

      var rawHtml = response.body.replaceAll(devPopularRepoDescriptionSelector, '<div id="repoDescription">');

      var html = parse(rawHtml);
      var htmlItems = html.querySelectorAll(devItemSelector);
      for (var htmlItem in htmlItems) {
        try {
          var avatar = htmlItem.querySelector(devAvatarSelector)?.attributes['src'] ?? '';
          var name = htmlItem.querySelector(devNameSelector)?.text.trim() ?? '';
          var username = htmlItem.querySelector(devUsernameSelector)?.text.trim() ?? '';
          var popularRepoName = htmlItem.querySelector(devPopularRepoNameSelector)?.text.trim() ?? '';
          var popularRepoDescription = htmlItem.querySelector('#repoDescription')?.text.trim() ?? '';
          result.add(GithubDeveloperItem(
            avatar: avatar,
            name: name,
            username: username,
            popularRepoName: popularRepoName,
            popularRepoDescription: popularRepoDescription,
          ));
        } catch (e) {
          print(['dev (var htmlItem in htmlItems)', e]);
        }
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  GithubTrendScraper copyWith({
    required String base,
    String? repoItemSelector,
    String? nameSelector,
    String? descriptionSelector,
    String? programmingLanguageSelector,
    String? totalStarsSelector,
    String? starsSinceSelector,
    String? totalForksSelector,
    String? topContributorsSelector,
    String? topContributorItemSelector,
    String? topContributorItemAttr,
    String? devItemSelector,
    String? devAvatarSelector,
    String? devNameSelector,
    String? devUsernameSelector,
    String? devPopularRepoNameSelector,
    String? devPopularRepoDescriptionSelector,
  }) {
    return GithubTrendScraper(
      base: base,
      repoItemSelector: repoItemSelector ?? this.repoItemSelector,
      nameSelector: nameSelector ?? this.nameSelector,
      descriptionSelector: descriptionSelector ?? this.descriptionSelector,
      programmingLanguageSelector: programmingLanguageSelector ?? this.programmingLanguageSelector,
      totalStarsSelector: totalStarsSelector ?? this.totalStarsSelector,
      starsSinceSelector: starsSinceSelector ?? this.starsSinceSelector,
      totalForksSelector: totalForksSelector ?? this.totalForksSelector,
      topContributorsSelector: topContributorsSelector ?? this.topContributorsSelector,
      topContributorItemSelector: topContributorItemSelector ?? this.topContributorItemSelector,
      topContributorItemAttr: topContributorItemAttr ?? this.topContributorItemAttr,
      devItemSelector: devItemSelector ?? this.devItemSelector,
      devAvatarSelector: devAvatarSelector ?? this.devAvatarSelector,
      devNameSelector: devNameSelector ?? this.devNameSelector,
      devUsernameSelector: devUsernameSelector ?? this.devUsernameSelector,
      devPopularRepoNameSelector: devPopularRepoNameSelector ?? this.devPopularRepoNameSelector,
      devPopularRepoDescriptionSelector: devPopularRepoDescriptionSelector ?? this.devPopularRepoDescriptionSelector,
    );
  }
}

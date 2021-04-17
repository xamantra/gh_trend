import 'package:gh_trend/gh_trend.dart';

void main() async {
  var repositories = await ghTrendingRepositories();
  for (var repo in repositories) {
    print('${repo.owner}/${repo.repoName}');
  }

  var developers = await ghTrendingDevelopers();
  for (var dev in developers) {
    print(dev.username);
  }
}

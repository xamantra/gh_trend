import 'index.dart';
import 'package:http/http.dart' as http;

Future<http.Response> request<T>(
  String path, {
  String proxy = '',
  Map<String, String> headers = const {},
}) async {
  var url = '$proxy$githubBase$path';
  print('$logHeader [GET] -> "$url"');
  var response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode != 200) {
    print('$logHeader [GET ${response.statusCode}] -> "$url"');
  }
  print('$logHeader [GET ${response.statusCode}] -> "$url"');
  return response;
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class SearchResult {
  final int total_count;
  final bool incomplete_results;
  final List<Repository> items;

  SearchResult(
      {required this.total_count,
      required this.incomplete_results,
      required this.items});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final List<Repository> items = (json["items"] as List)
        .map((item) => Repository.fromJson(item))
        .toList();

    return SearchResult(
        total_count: json["total_count"],
        incomplete_results: json["incomplete_results"],
        items: items);
  }

  factory SearchResult.empty() {
    return SearchResult(
        total_count: 0, incomplete_results: false, items: <Repository>[]);
  }
}

class Repository {
  final String name;
  final String full_name;
  final String html_url;
  final String description;
  final String avatar_url;

  Repository(
      {required this.name,
      required this.full_name,
      required this.html_url,
      required this.description,
      required this.avatar_url});

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
        name: json["name"],
        full_name: json["full_name"],
        html_url: json["html_url"],
        description: json["description"] == null ? "" : json["description"],
        avatar_url: json["owner"]["avatar_url"] == null
            ? ""
            : json["owner"]["avatar_url"]);
  }
}

Future<SearchResult> search(String query) async {
  String baseUrl = "api.github.com";
  String endpoint = "/search/repositories";

  final uri = Uri.https(baseUrl, endpoint, {"q": Uri.encodeComponent(query)});
  log(uri.toString());

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return SearchResult.fromJson(jsonDecode(response.body));
  } else {
    return SearchResult.empty();
  }
}

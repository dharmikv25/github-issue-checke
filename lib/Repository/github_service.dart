import 'dart:convert';
import 'package:githubproject/model/issue_model.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  Future<List<GitIssue>> fetchIssues(String owner, String repo, int page,String state) async {
    final url = 'https://api.github.com/repos/$owner/$repo/issues?page=$page&per_page=10&state=$state';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => GitIssue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch issues: ${response.statusCode}');
    }
  }
}
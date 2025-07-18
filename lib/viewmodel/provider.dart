import 'package:flutter/material.dart';
import 'package:githubproject/model/issue_model.dart';
import 'package:githubproject/Repository/github_service.dart';

class IProvider extends ChangeNotifier {
  final GitHubService _service = GitHubService();
  List<GitIssue> _issues = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _page = 1;
  bool _hasMore = true;
  String _issueState = 'all';

  List<GitIssue> get issues => _issues;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  String get issueState => _issueState;
  void setIssueState(String state) {
    _issueState = state;
    notifyListeners();
  }

  Future<void> fetchIssues(String url, {bool loadMore = false}) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      if (!loadMore) {
        _issues.clear();
        _page = 1;
        _hasMore = true;
      }

      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.length < 2) {
        throw Exception('Invalid GitHub repository URL');
      }

      final owner = segments[0];
      final repo = segments[1];
      final newIssues = await _service.fetchIssues(
        owner,
        repo,
        _page,
        _issueState,
      );

      if (newIssues.length < 10) _hasMore = false;
      _issues.addAll(newIssues);
      _page++;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

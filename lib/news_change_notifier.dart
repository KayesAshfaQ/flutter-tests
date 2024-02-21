import 'package:flutter/material.dart';
import 'package:flutter_tests/models/article.dart';

import 'services/news_service.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsService _newsService;

  NewsChangeNotifier(this._newsService);

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    // TODO : Implement the getArticles method
  }
}

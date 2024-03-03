import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/news_service.dart';

class NewsChangeProvider extends ChangeNotifier {
  final NewsService _newsService;

  NewsChangeProvider(this._newsService);

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchArticles() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _newsService.getArticles();
    _isLoading = false;
    notifyListeners();
  }
}

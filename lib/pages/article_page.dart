import 'package:flutter/material.dart';

import '../models/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          article.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

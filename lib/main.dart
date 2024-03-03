import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/news_change_provider.dart';
import 'pages/news_page.dart';
import 'services/news_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeProvider(NewsService()),
        child: const NewsPage(),
      ),
    );
  }
}

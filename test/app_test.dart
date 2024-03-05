import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/models/article.dart';
import 'package:flutter_tests/pages/article_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tests/pages/news_page.dart';
import 'package:flutter_tests/providers/news_change_provider.dart';
import 'package:flutter_tests/services/news_service.dart';

// this is a better approach, cause it has less boilerplate code
// the implementation of the NewsService is done by the mock package
class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final mockArticles = [
    Article(title: 'Article 1', content: 'Content 1'),
    Article(title: 'Article 2', content: 'Content 2'),
    Article(title: 'Article 3', content: 'Content 3'),
  ];

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Test App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeProvider(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    '''Tapping on the first article excerpt opens the article page,
    where the full article content is displayed''',
    (WidgetTester tester) async {
      // arrange
      when(() => mockNewsService.getArticles()).thenAnswer((_) async => mockArticles);

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      await tester.tap(find.text('Content 1'));

      await tester.pumpAndSettle();

      // assert
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);

      expect(find.text('Article 1'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tests/models/article.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeProvider(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    'title is displayed',
    (WidgetTester tester) async {
      // arrange
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => mockArticles,
      );

      // act
      await tester.pumpWidget(createWidgetUnderTest());

      // assert
      expect(find.text('News'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed when loading articles",
    (WidgetTester tester) async {
      // mock the getArticles method to return the articles after 2 seconds
      when(() => mockNewsService.getArticles()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return mockArticles;
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // ensures the loading indicator is displayed by rebuilding
      await tester.pump(const Duration(milliseconds: 1900));

      // assert the loading indicator is displayed
      expect(find.byKey(const Key('progress-loader')), findsOneWidget);

      // ensures nothing still pending (timer in this case)
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "articles are displayed",
    (WidgetTester tester) async {
      when(() => mockNewsService.getArticles()).thenAnswer((_) async => mockArticles);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      for (final article in mockArticles) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }

      await tester.pumpAndSettle();
    },
  );
}

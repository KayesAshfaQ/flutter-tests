import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_tests/models/article.dart';
import 'package:flutter_tests/providers/news_change_provider.dart';
import 'package:flutter_tests/services/news_service.dart';

// this is a bad approach, cause it has a lot of boilerplate code
class BadMockNewsService implements NewsService {
  bool getArticlesCalled = false;

  @override
  Future<List<Article>> getArticles() async {
    getArticlesCalled = true;
    return [
      Article(
        title: 'Article 1',
        content: 'Content 1',
      ),
      Article(
        title: 'Article 2',
        content: 'Content 2',
      ),
      Article(
        title: 'Article 3',
        content: 'Content 3',
      ),
    ];
  }
}

// this is a better approach, cause it has less boilerplate code
// the implementation of the NewsService is done by the mock package
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeProvider sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeProvider(mockNewsService);
  });

  test(
    'initial values are correct',
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group(
    'fetch articles',
    () {
      final mockArticles = [
        Article(title: 'Article 1', content: 'Content 1'),
        Article(title: 'Article 2', content: 'Content 2'),
        Article(title: 'Article 3', content: 'Content 3'),
      ];

      void mockNewsServiceGetArticlesArranger() {
        when(() => mockNewsService.getArticles()).thenAnswer(
          (_) async => mockArticles,
        );
      }

      test(
        'fetchArticles using the news service',
        () async {
          // arrange
          mockNewsServiceGetArticlesArranger();

          // act
          await sut.fetchArticles();

          // assert
          verify(() => mockNewsService.getArticles()).called(1);
        },
      );

      test(
        '''indicates loading of data,
        sets articles to the ones form the service,
        indicates data is not being loaded anymore''',
        () async {
          // arrange
          mockNewsServiceGetArticlesArranger();

          // act
          final future = sut.fetchArticles();

          // assert
          expect(sut.isLoading, true);
          await future;
          expect(sut.isLoading, false);
          expect(sut.articles.length, 3);
          expect(sut.articles, mockArticles);
        },
      );
    },
  );
}

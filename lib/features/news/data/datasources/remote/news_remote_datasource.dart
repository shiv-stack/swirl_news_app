import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swirl_news_app/features/news/data/models/news_model.dart';


abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getTopHeadlines(int page, int pageSize);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  final String apiKey;

  NewsRemoteDataSourceImpl(this.client, this.apiKey);

  @override
  Future<List<NewsModel>> getTopHeadlines(
      int page, int pageSize) async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&page=$page&pageSize=$pageSize&apiKey=$apiKey';

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['articles'] as List)
          .map((e) => NewsModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Server Error');
    }
  }
}

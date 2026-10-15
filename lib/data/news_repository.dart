import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class NewsRepository {
  static const String _baseUrl = 'https://saurav.tech/NewsAPI';

  Future<List<Article>> byCategory(String category) async {
    final uri = Uri.parse('$_baseUrl/top-headlines/category/$category/us.json');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List rawArticles = data['articles'] ?? [];
      return rawArticles.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news (Code: ${response.statusCode})');
    }
  }

  Future<List<Article>> search(String query) async {
    final allArticles = await byCategory('general');
    if (query.trim().isEmpty) return allArticles;

    return allArticles.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
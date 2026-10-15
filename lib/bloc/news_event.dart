sealed class NewsEvent {}

class FetchCategory extends NewsEvent {
  final String category;
  FetchCategory(this.category);
}

class SearchNews extends NewsEvent {
  final String query;
  SearchNews(this.query);
}
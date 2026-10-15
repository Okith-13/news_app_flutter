import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../data/news_model.dart';
import '../data/news_repository.dart';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final NewsBloc newsBloc;
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    newsBloc = NewsBloc(NewsRepository());
  }

  @override
  void dispose() {
    newsBloc.close();
    searchController.dispose();
    super.dispose();
  }

  void search() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      newsBloc.add(SearchNews(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      bloc: newsBloc,
      listener: (context, state) {
        if (state is NewsLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is NewsLoaded) {
          setState(() {
            articles = state.articles;
            isLoading = false;
          });
        } else if (state is NewsError) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => search(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: search,
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isLoading && articles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('${articles.length} results'),
                ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is NewsError
                        ? Center(
                            child: ElevatedButton(
                              onPressed: search,
                              child: const Text('Retry'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final item = articles[index];
                              return ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.blue.shade100,
                                  child: item.imageUrl.isNotEmpty
                                      ? Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                        )
                                      : const Icon(Icons.image),
                                ),
                                title: Text(item.title, maxLines: 2),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsPage(article: item),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
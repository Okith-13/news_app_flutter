import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../data/news_model.dart';
import '../data/news_repository.dart';
import 'details_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NewsBloc newsBloc;

  bool isLoading = true;
  List<Article> articles = [];
  String currentCategory = 'sports';

  @override
  void initState() {
    super.initState();
    newsBloc = NewsBloc(NewsRepository());
    newsBloc.add(FetchCategory(currentCategory));
  }

  @override
  void dispose() {
    newsBloc.close();
    super.dispose();
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
            title: const Text('Top News', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Category Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Sports'),
                      selected: currentCategory == 'sports',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => currentCategory = 'sports');
                          newsBloc.add(FetchCategory('sports'));
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Tech'),
                      selected: currentCategory == 'technology',
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => currentCategory = 'technology');
                          newsBloc.add(FetchCategory('technology'));
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Article list / loading / error
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is NewsError
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () => newsBloc.add(FetchCategory(currentCategory)),
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
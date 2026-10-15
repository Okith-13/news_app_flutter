// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../data/news_repository.dart';
// import 'news_event.dart';
// import 'news_state.dart';

// class NewsBloc extends Bloc<NewsEvent, NewsState> {
//   final NewsRepository repo;

//   NewsBloc(this.repo) : super(NewsLoading()) {
//     on<FetchCategory>((event, emit) async {
//       emit(NewsLoading());
//       try {
//         final articles = await repo.byCategory(event.category);
//         emit(NewsLoaded(articles));
//       } catch (e) {
//         emit(NewsError('Could not load news. Please try again.'));
//       }
//     });

//     on<SearchNews>((event, emit) async {
//       emit(NewsLoading());
//       try {
//         final articles = await repo.search(event.query);
//         emit(NewsLoaded(articles));
//       } catch (e) {
//         emit(NewsError('Could not perform search. Please try again.'));
//       }
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repo;

  NewsBloc(this.repo) : super(NewsLoading()) {
    on<FetchCategory>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await repo.byCategory(event.category);
        emit(NewsLoaded(articles));
      } catch (e, stack) {
        print('FetchCategory Error: $e');
        print(stack);
        emit(NewsError('Could not load news. Please try again.'));
      }
    });

    on<SearchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await repo.search(event.query);
        emit(NewsLoaded(articles));
      } catch (e, stack) {
        print('SearchNews Error: $e');
        print(stack);
        emit(NewsError('Could not perform search. Please try again.'));
      }
    });
  }
}
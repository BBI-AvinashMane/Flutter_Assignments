import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';

// Fallback classes for mocktail
class FakeNewsEvent extends Fake implements NewsEvent {}
class FakeNewsState extends Fake implements NewsState {}

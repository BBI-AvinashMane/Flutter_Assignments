import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/domain/usecases/get_news.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';

class MockGetNews extends Mock implements GetNews {}

class FakeNewsEvent extends Fake implements NewsEvent {}

class FakeNewsState extends Fake implements NewsState {}

import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNewsEvent extends NewsEvent {
  final String query;
  final String? language;
  final int page;
  final int pageSize;

  const LoadNewsEvent({
    required this.query,
    this.language="en",
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [query, language, page, pageSize];
}

class RefreshNewsEvent extends NewsEvent {
  final String query;
  final String? language;
  final int pageSize;

  const RefreshNewsEvent({
    required this.query,
    this.language="en",
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [query, language, pageSize];
}

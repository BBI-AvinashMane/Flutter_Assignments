import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNewsEvent extends NewsEvent {
  final String query;
  final String? category;
  final String? language;
  final String? country;

  const LoadNewsEvent({
    required this.query,
    this.category,
    this.language,
    this.country,
  });

  @override
  List<Object?> get props => [query, category, language, country];
}

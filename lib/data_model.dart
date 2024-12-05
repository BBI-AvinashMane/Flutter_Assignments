class DataModel {
  final int? id;
  final String? title;
  final String? body;

  DataModel({this.id, this.title, this.body});

  // Factory method to create an instance from a JSON map
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['it'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
    );
  }
}

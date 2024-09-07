class CatBreedsModel {
  final String path;
  final int perPage;
  final int total;

  CatBreedsModel({
    required this.path,
    required this.perPage,
    required this.total,
  });

  // Factory method to create a Fact instance from JSON
  factory CatBreedsModel.fromJson(Map<String, dynamic> json) {
    return CatBreedsModel(
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }

  // Method to convert a Fact instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'per_page': perPage,
      'total': total,
    };
  }
}

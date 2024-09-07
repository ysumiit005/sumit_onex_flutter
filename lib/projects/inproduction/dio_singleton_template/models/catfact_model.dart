class CatfactModel {
  final String fact;
  final int length;

  CatfactModel({
    required this.fact,
    required this.length,
  });

  // Factory method to create a Fact instance from JSON
  factory CatfactModel.fromJson(Map<String, dynamic> json) {
    return CatfactModel(
      fact: json['fact'] as String,
      length: json['length'] as int,
    );
  }

  // Method to convert a Fact instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fact': fact,
      'length': length,
    };
  }
}

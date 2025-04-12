class Category {
  final String title;
  final String slug;
  final String filename;

  Category({
    required this.title,
    required this.slug,
    required this.filename,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      slug: json['slug'],
      filename: json['filename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'slug': slug,
      'filename': filename,
    };
  }
}

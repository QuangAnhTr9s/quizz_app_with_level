class Category {
  final String title;
  final String slug;
  final String filename;
  final String? image;
  final int price;

  Category({
    required this.title,
    required this.slug,
    required this.filename,
    this.image,
    required this.price,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      slug: json['slug'],
      filename: json['filename'],
      image: json['image'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'slug': slug,
      'filename': filename,
      'image': image,
      'price': price,
    };
  }
}

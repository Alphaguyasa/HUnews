class Post {
  final int id;
  final String date;
  final String title;
  final String excerpt;
  final String content;
  final String link;
  final String? imageUrl;
  final List<String> galleryImages;



  Post({
    required this.id,
    required this.date,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.link,
    this.imageUrl,
    this.galleryImages = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final yoastHead = json['yoast_head'] ?? '';
    final imageRegex = RegExp(r'<meta property="og:image" content="(.*?)"');
    final match = imageRegex.firstMatch(yoastHead);

    final imageUrl = match?.group(1)?.replaceAll('.avif', '.jpg');

    // Extract all images from content for horizontal gallery
    final contentHtml = json['content']['rendered'] ?? '';
    final imgTagRegex = RegExp(r'<img[^>]+src="([^">]+)"', caseSensitive: false);
    final galleryImages = <String>[];
    for (final match in imgTagRegex.allMatches(contentHtml)) {
      String url = match.group(1) ?? '';
      if (url.endsWith('.avif')) url = url.replaceAll('.avif', '.jpg');
      galleryImages.add(url);
    }

    return Post(
      id: json['id'],
      date: json['date'].toString(),
      title: json['title']['rendered'] ?? '',
      excerpt: json['excerpt']['rendered'] ?? '',
      content: contentHtml,
      link: json['link'] ?? '',
      imageUrl: imageUrl,
      galleryImages: galleryImages,
    );
  }
}
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
    // 1. Try featured image from _embedded (most reliable)
    String? imageUrl;
    try {
      final embedded = json['_embedded'];
      if (embedded != null) {
        final featuredMedia = embedded['wp:featuredmedia'];
        if (featuredMedia != null && featuredMedia is List && featuredMedia.isNotEmpty) {
          final media = featuredMedia[0];
          // Try full size first, then medium_large, then medium
          final sizes = media['media_details']?['sizes'];
          if (sizes != null) {
            imageUrl = sizes['full']?['source_url'] ??
                sizes['large']?['source_url'] ??
                sizes['medium_large']?['source_url'] ??
                sizes['medium']?['source_url'];
          }
          // Fallback to source_url directly
          imageUrl ??= media['source_url']?.toString();
        }
      }
    } catch (_) {}

    // 2. Fallback: try yoast_head og:image
    if (imageUrl == null || imageUrl.isEmpty) {
      final yoastHead = json['yoast_head'] ?? '';
      final imageRegex = RegExp(r'<meta property="og:image" content="(.*?)"');
      final match = imageRegex.firstMatch(yoastHead);
      imageUrl = match?.group(1);
    }

    // Replace .avif with .jpg
    if (imageUrl != null) {
      imageUrl = imageUrl.replaceAll('.avif', '.jpg');
    }

    // Extract all images from content for horizontal gallery
    final contentHtml = json['content']['rendered'] ?? '';
    final imgTagRegex = RegExp(r'<img[^>]+src="([^">]+)"', caseSensitive: false);
    final galleryImages = <String>[];
    for (final match in imgTagRegex.allMatches(contentHtml)) {
      String url = match.group(1) ?? '';
      if (url.endsWith('.avif')) url = url.replaceAll('.avif', '.jpg');
      galleryImages.add(url);
    }

    // 3. Fallback: use first content image if still no image
    imageUrl ??= galleryImages.isNotEmpty ? galleryImages.first : null;

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
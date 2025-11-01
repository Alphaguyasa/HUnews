
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';
import 'post_detail_screen.dart';
import 'video_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Post> filteredPosts = [];
  String keyword = "";

  void _filterPosts(List<Post> allPosts) {
    keyword = _controller.text.toLowerCase();
    setState(() {
      filteredPosts = allPosts
          .where((post) =>
      (post.title ?? "").toLowerCase().contains(keyword) ||
          (post.excerpt ?? "").toLowerCase().contains(keyword))
          .toList();
    });
  }

  TextSpan _highlightText(String text, String keyword, Color highlightColor) {
    if (keyword.isEmpty) return TextSpan(text: text);
    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    int start = 0;
    int index;
    while ((index = lowerText.indexOf(keyword, start)) != -1) {
      if (index > start) spans.add(TextSpan(text: text.substring(start, index)));
      spans.add(TextSpan(
          text: text.substring(index, index + keyword.length),
          style: TextStyle(color: highlightColor, fontWeight: FontWeight.bold)));
      start = index + keyword.length;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return TextSpan(children: spans);
  }

  /// ✅ Helper: Extract YouTube URL from post content
  String? extractYouTubeUrl(String content) {
    final regex = RegExp(
        r'(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)[\w\-]+');
    final match = regex.firstMatch(content);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    final allPosts =
        (ModalRoute.of(context)?.settings.arguments as List<Post>?) ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF1B365D),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: "Search posts...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)),
              onChanged: (_) => _filterPosts(allPosts),
            ),
          ),
          Expanded(
            child: filteredPosts.isEmpty
                ? const Center(child: Text("No posts found"))
                : ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                final youtubeUrl = extractYouTubeUrl(post.content);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        if (youtubeUrl != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    VideoScreen(videoUrl: youtubeUrl)),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    PostDetailScreen(post: post)),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              // Post image
                              CachedNetworkImage(
                                imageUrl: post.imageUrl?.isNotEmpty == true
                                    ? post.imageUrl!
                                    : 'https://ssgi.gov.et/wp-content/uploads/2023/04/header-logo.jpg',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  height: 180,
                                  child: const Center(
                                      child: Icon(Icons.image,
                                          color: Colors.grey, size: 50)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  height: 180,
                                  child: const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.grey, size: 50)),
                                ),
                              ),
                              // YouTube overlay
                              if (youtubeUrl != null)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.play_circle_fill,
                                        color: Colors.red, size: 28),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: _highlightText(
                                      post.title ?? "", keyword,
                                      const Color(0xFF1B365D)),
                                ),
                                const SizedBox(height: 8),
                                HtmlWidget(post.excerpt ?? ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
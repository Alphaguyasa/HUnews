import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

import '../services/api_service.dart';
import 'post_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> allPosts = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool isDarkMode = false;

  final Color ssgiBlue = const Color(0xFF1B365D);
  final Color telegramBlue = const Color(0xFF229ED9);
  final Color websiteGreen = const Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
    loadPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        if (!isLoading && hasMore) loadPosts();
      }
    });
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> loadPosts() async {
    if (!hasMore || isLoading) return;
    setState(() => isLoading = true);

    try {
      final posts = await ApiService.fetchPostsByPage(currentPage);
      if (posts.isEmpty) {
        hasMore = false;
      } else {
        allPosts.addAll(posts);
        currentPage++;
      }
    } catch (e) {
      hasMore = false;
      debugPrint("Failed to load posts: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load news. Check your connection.'),
            backgroundColor: Colors.redAccent,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                setState(() => hasMore = true);
                loadPosts();
              },
            ),
          ),
        );
      }
    }

    setState(() => isLoading = false);
  }

  void scrollToTop() => _scrollController.animateTo(
    0,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        scrollToTop();
        break;
      case 1:
        _launchURL("https://t.me/haramayauniversity");
        break;
      case 2:
        _launchURL("https://www.haramaya.edu.et/");
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const SearchScreen(),
              settings: RouteSettings(arguments: allPosts)),
        );
        break;
      case 4:
        setState(() {
          allPosts.clear();
          currentPage = 1;
          hasMore = true;
        });
        loadPosts();
        break;
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    _saveDarkModePreference(isDarkMode);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredPosts = allPosts.take(5).toList();
    final otherPosts = allPosts.skip(5).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                'https://www.haramaya.edu.et/wp-content/uploads/2020/09/HU-Logo.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                const Icon(Icons.image, color: Colors.white, size: 50),
                errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 50),
              ),
              const SizedBox(width: 12),
              const Text(
                "HU News",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                  isDarkMode ? Icons.dark_mode_sharp : Icons.light_mode,
                  color: Colors.blue),
              onPressed: toggleTheme,
            ),
          ],
        ),
        body: Stack(
          children: [
            allPosts.isEmpty && isLoading
                ? Center(child: CircularProgressIndicator(color: ssgiBlue))
                : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Featured News",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B365D))),
                  ),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredPosts.length,
                      itemBuilder: (context, index) {
                        final post = featuredPosts[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 12.0 : 8.0, right: 12.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      PostDetailScreen(post: post)),
                            ),
                            child: SizedBox(
                              width: 280,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: post.imageUrl != null && post.imageUrl!.isNotEmpty
                                          ? post.imageUrl!
                                          : 'https://www.haramaya.edu.et/wp-content/uploads/2020/09/HU-Logo.png',
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(
                                            color: Colors.grey[300],
                                            height: 160,
                                            child: const Center(
                                                child: Icon(Icons.image,
                                                    color: Colors.grey,
                                                    size: 50)),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            color: Colors.grey[300],
                                            height: 160,
                                            child: const Center(
                                                child: Icon(Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 50)),
                                          ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          post.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Latest News",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B365D))),
                  ),
                  ListView.builder(
                    itemCount: otherPosts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final post = otherPosts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      PostDetailScreen(post: post)),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: post.imageUrl != null && post.imageUrl!.isNotEmpty
                                      ? post.imageUrl!
                                      : 'https://www.haramaya.edu.et/wp-content/uploads/2020/09/HU-Logo.png',
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(
                                        color: Colors.grey[300],
                                        height: 180,
                                        child: const Center(
                                            child: Icon(Icons.image,
                                                color: Colors.grey, size: 50)),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[300],
                                        height: 180,
                                        child: const Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey, size: 50)),
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(post.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange)),
                                      const SizedBox(height: 8),
                                      HtmlWidget(post.excerpt),
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
                  if (hasMore)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : loadPosts,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ssgiBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12)),
                          child: isLoading
                              ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                              : const Text("Load More Posts"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 40,
              child: FloatingActionButton(
                heroTag: "scrollTop",
                mini: true,
                backgroundColor: ssgiBlue,
                onPressed: scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5)),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, "Home", 0, ssgiBlue),
                _navItem(Icons.telegram, "Telegram", 1, telegramBlue),
                _navItem(Icons.public, "Website", 2, websiteGreen),
                _navItem(Icons.search, "Search", 3, Colors.orange),
                _navItem(Icons.refresh, "Refresh", 4, Colors.redAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, Color activeColor) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 26),
            Text(
              label,
              style: TextStyle(
                  color: isSelected ? activeColor : Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
  }
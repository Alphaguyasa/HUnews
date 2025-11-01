import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool isLiked = false;
  bool isHearted = false;
  bool isFired = false;
  bool isDisliked = false;

  // Counters
  int likeCount = 0;
  int dislikeCount = 0;
  int heartCount = 0;
  int fireCount = 0;

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate).toLocal();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String dayOfWeek(String isoDate) {
    final date = DateTime.parse(isoDate);
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[date.weekday % 7];
  }

  // Function to reset all reactions except the one tapped
  void resetOtherReactions(String tapped) {
    if (tapped != 'like' && isLiked) {
      isLiked = false;
      likeCount--;
    }
    if (tapped != 'dislike' && isDisliked) {
      isDisliked = false;
      dislikeCount--;
    }
    if (tapped != 'heart' && isHearted) {
      isHearted = false;
      heartCount--;
    }
    if (tapped != 'fire' && isFired) {
      isFired = false;
      fireCount--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B365D),
        title: Text(
          widget.post.title,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.post.imageUrl!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              widget.post.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color:  Colors.orange,
              ),
            ),
            const SizedBox(height: 8),

            // Text(
            //     formatDate(widget.post.date),
            //     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            //   ),

            Row(
              children: [
                Text(
                  dayOfWeek(widget.post.date),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(width: 5),
                Text(
                  formatDate(widget.post.date),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            HtmlWidget(
              widget.post.content,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.6, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: isLiked ? const Color(0xFFF6B331) : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (!isLiked) {
                            resetOtherReactions('like');
                            isLiked = true;
                            likeCount++;
                          } else {
                            isLiked = false;
                            likeCount--;
                          }
                        });
                      },
                    ),
                    Text('$likeCount'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: isDisliked ? const Color(0xFFF7B331) : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (!isDisliked) {
                            resetOtherReactions('dislike');
                            isDisliked = true;
                            dislikeCount++;
                          } else {
                            isDisliked = false;
                            dislikeCount--;
                          }
                        });
                      },
                    ),
                    Text('$dislikeCount'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isHearted ? const Color(0xFFE53935) : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (!isHearted) {
                            resetOtherReactions('heart');
                            isHearted = true;
                            heartCount++;
                          } else {
                            isHearted = false;
                            heartCount--;
                          }
                        });
                      },
                    ),
                    Text('$heartCount'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.local_fire_department,
                        color: isFired ? const Color(0xFFFB8C00) : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (!isFired) {
                            resetOtherReactions('fire');
                            isFired = true;
                            fireCount++;
                          } else {
                            isFired = false;
                            fireCount--;
                          }
                        });
                      },
                    ),
                    Text('$fireCount'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  }
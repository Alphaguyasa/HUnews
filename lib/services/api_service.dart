
// import 'dart:convert';
//  import 'package:http/http.dart' as http;
//  import '../models/post_model.dart'; // Keep only one correct import
// class ApiService {
//   static const String baseUrl = 'https://ssgi.gov.et/wp-json/wp/v2/posts';
//
//   // Legacy method — unused in pagination flow
//   static Future<List<Post>> fetchAllPosts() async {
//     int page = 1;
//     List<Post> allPosts = [];
//
//     while (true) {
//       final response = await http.get(
//         Uri.parse('$baseUrl?page=$page&per_page=10'),
//       );
//
//       if (response.statusCode == 200) {
//         List jsonData = jsonDecode(response.body);
//         if (jsonData.isEmpty) break;
//
//         final posts = jsonData.map((json) => Post.fromJson(json)).toList();
//         allPosts.addAll(posts);
//
//         final totalPages = int.tryParse(
//           response.headers['x-wp-totalpages'] ?? '1',
//         ) ??
//             1;
//
//         if (page >= totalPages) break;
//         page++;
//       } else {
//         print('Failed on page $page: ${response.statusCode}');
//         break;
//       }
//     }
//
//     return allPosts;
//   }
//
//   // ✅ New paginated method
//   static Future<List<Post>> fetchPostsByPage(int page) async {
//     const int perPage = 10;
//     final response = await http.get(
//       Uri.parse('$baseUrl?page=$page&per_page=$perPage'),
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = jsonDecode(response.body);
//       return jsonData.map((json) => Post.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load posts: ${response.statusCode}');
//     }
//   }
// }
//
//
//

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://ssgi.gov.et/wp-json/wp/v2/posts';

  static Future<List<Post>> fetchPostsByPage(int page) async {
    const int perPage = 10;
    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&per_page=$perPage'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }
}
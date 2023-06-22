import 'dart:convert';

import 'package:bloc_api_demo/core/model/comment_post_model.dart';
import 'package:bloc_api_demo/core/model/post_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<PostModelClass>> getAllPosts() async {
    try {
      final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<PostModelClass> posts = [];

        for (var postData in data) {
          PostModelClass post = PostModelClass.fromJson(postData);
          posts.add(post);
        }

        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    }
    catch(e){
      rethrow;
    }
  }

  static Future<List<CommentModelClass>> getAllCommentsPosts() async {
    try {
      dynamic response =
      await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1/comments'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<CommentModelClass> comments = [];

        for (var postData in data) {
          CommentModelClass post = CommentModelClass.fromJson(postData);
          comments.add(post);
        }

        return comments;
      } else {
        throw Exception('Failed to load posts');
      }
    }
    catch (e){
      rethrow;
    }
  }

  static Future<List<CommentModelClass>> fetchCommentsByPostId(int postId) async {
    try{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> commentData = json.decode(response.body);
      List<CommentModelClass> comments = [];

      for (var commentDataItem in commentData) {
        final comment = CommentModelClass.fromJson(commentDataItem);
        comments.add(comment);
      }

      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
    }
    catch(e){
      rethrow;
    }
  }
  
}

import 'package:bloc_api_demo/core/model/comment_post_model.dart';
import 'package:bloc_api_demo/core/model/merged_post_comment.dart';
import 'package:bloc_api_demo/core/model/post_model.dart';
import 'package:bloc_api_demo/core/repository/user_repository.dart';
import 'package:bloc_api_demo/core/view_model/home_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class HomeBloc extends Cubit<HomeViewState> {
  final UserRepository _userRepository = UserRepository();
  List<MergedPostComment> mergedData = [];

  String _searchQuery = '';

  HomeBloc() : super(HomeViewStateLoading()) {
    init();
  }

  void init() async {
    try {
      final List<PostModelClass> posts = await _userRepository.getAllPosts();
      for (PostModelClass post in posts) {
        List<CommentModelClass> postComments =
        await _userRepository.fetchCommentsByPostId(post.id!);
        mergedData.add(
          MergedPostComment(
            postId: post.id!,
            postTitle: post.title!,
            postBody: post.body!,
            comments: postComments,
          ),
        );
      }

      emit(HomeViewStateLoaded(mergedData));
    } catch (e) {
      emit(HomeViewStateError(e.toString()));
    }
  }

  void fetchData(){
    emit(HomeViewStateLoaded(mergedData));
  }

  void filterData(String query) {
    final currentState = state;
    if (currentState is HomeViewStateLoaded) {
      List<MergedPostComment> filteredData;
      if (query.isNotEmpty) {
        int? postId = int.tryParse(query);
        filteredData =
            currentState.mergedData.where((data) => data.postId == postId).toList();
        emit(HomeViewStateFiltered(filteredData));
      }
      else {
        filteredData = List.from(mergedData);
      }
     emit(HomeViewStateFiltered(filteredData));
    }
  }




}

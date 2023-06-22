import 'package:bloc_api_demo/core/model/merged_post_comment.dart';

abstract class HomeViewState {}

class HomeViewStateLoading extends HomeViewState {}

class HomeViewStateLoaded extends HomeViewState {
  final List<MergedPostComment> mergedData;

  HomeViewStateLoaded(this.mergedData);
}

class HomeViewStateFiltered extends HomeViewState {
  final List<MergedPostComment> filteredData;

  HomeViewStateFiltered(this.filteredData);
}

class HomeViewStateError extends HomeViewState {
  final String error;

  HomeViewStateError(this.error);
}

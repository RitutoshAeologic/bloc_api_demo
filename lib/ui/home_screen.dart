import 'package:bloc_api_demo/core/model/comment_post_model.dart';
import 'package:bloc_api_demo/core/model/merged_post_comment.dart';
import 'package:bloc_api_demo/core/view_model/home_view_model.dart';
import 'package:bloc_api_demo/core/view_model/home_view_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  HomeBloc _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          BlocBuilder<HomeBloc,HomeViewState>(builder: (context, state) {
            return   FloatingActionButton(
                onPressed:(){
                  BlocProvider.of<HomeBloc>(context).fetchData();
                } ,
                backgroundColor: Colors.blue,
                elevation: 0,
                child: Icon(Icons.refresh,color: Colors.black,));
          } ),
     
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              // onChanged: (value) {
              //   if (value.isNotEmpty) {
              //     BlocProvider.of<HomeBloc>(context).filterData(value);
              //   } else {
              //     BlocProvider.of<HomeBloc>(context).mergedData;
              //   }
              //   //_searchController.clear();
              // },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  BlocProvider.of<HomeBloc>(context).filterData(value);
                } else {
                  BlocProvider.of<HomeBloc>(context).mergedData;
                }
                _searchController.clear();
              },
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<HomeBloc, HomeViewState>(
            //  bloc: _homeBloc,
              listener: (context, state) {
                // if (state is HomeViewStateFiltered) {
                //   final searchQuery = _searchController.text.trim();
                //   if (searchQuery.isNotEmpty) {
                //     final filteredData = state.filteredData
                //         .where((data) => data.postId.toString() == searchQuery)
                //         .toList();
                //     BlocProvider.of<HomeBloc>(context).filterData(searchQuery);
                //   }
                // }
                // else if (state is HomeViewStateLoaded){
                //   BlocProvider.of<HomeBloc>(context).mergedData;
                // }
              },
              builder: (context, state) {
                if (state is HomeViewStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeViewStateLoaded) {
                  // final filteredData = _searchController.text.isEmpty
                  //     ? state.mergedData
                  //     : state.mergedData
                  //     .where((data) =>
                  // data.postTitle
                  //     .toLowerCase()
                  //     .contains(_searchController.text.toLowerCase()) ||
                  //     data.postBody
                  //         .toLowerCase()
                  //         .contains(_searchController.text.toLowerCase()))
                  //     .toList();
                  return _buildLoadedView(state.mergedData);
                } else if (state is HomeViewStateFiltered) {
                  return _buildFilteredView(state.filteredData);
                } else if (state is HomeViewStateError) {
                  return Center(child: Text(state.error));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedView(List<MergedPostComment> displayedData) {
    return ListView.builder(
      itemCount: displayedData.length,
      itemBuilder: (context, index) {
        final MergedPostComment data = displayedData[index];
        return _buildPostCommentItem(data);
      },
    );
  }

  Widget _buildFilteredView(List<MergedPostComment> displayedData) {
    if (displayedData.isEmpty) {
      return Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: displayedData.length,
      itemBuilder: (context, index) {
        final MergedPostComment data = displayedData[index];
        return _buildPostCommentItem(data);
      },
    );
  }


  Widget _buildPostCommentItem(MergedPostComment data) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text('ID: ${data.postId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${data.postTitle}'),
            Text('Body: ${data.postBody}'),
            const SizedBox(height: 8),
            Text('Comments (${data.comments.length}):'),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.comments.length,
                itemBuilder: (context, commentIndex) {
                  final CommentModelClass comment = data.comments[commentIndex];
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Post ID: ${comment.postId}'),
                        Text('Name: ${comment.name}'),
                        Text('Email: ${comment.email}'),
                        Text('Body: ${comment.body}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

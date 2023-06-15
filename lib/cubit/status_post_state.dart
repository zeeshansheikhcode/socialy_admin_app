part of 'status_post_cubit.dart';

abstract class StatusPostState extends Equatable {
  const StatusPostState();

  @override
  List<Object> get props => [];

 // get posts => null;
}

class StatusPostInitial extends StatusPostState {}

class StatusPostLoadingState extends StatusPostState {}
class StatusLoadingState extends StatusPostState {}
class PostLoadingState extends StatusPostState {}

class StatusPostLoadedState extends StatusPostState {
  final List<List<StoryModel>>? allStories;
  final List<PostModel>? allPost;
  const StatusPostLoadedState({this.allStories,this.allPost});
 
  @override
  List<Object> get props => [allStories!,allPost!];
}

class StatusLoadedState extends StatusPostState {
  final List<List<StoryModel>>? allStories;
  const StatusLoadedState({this.allStories});
  @override
  List<Object> get props => [allStories! ];
}
class PostLoadedState extends StatusPostState {
  final List<PostModel>? allPost;
  const PostLoadedState({this.allPost});
  @override
  List<Object> get props => [allPost! ];
}

class CommentsLoadedState extends StatusPostState 
{
   final List<Comment>? allComments;
   const CommentsLoadedState({this.allComments});
   
   @override
  List<Object> get props => [allComments!];

}
class LikesLoadedState extends StatusPostState 
{
   final PostModel? allPostLikes;
   const LikesLoadedState({this.allPostLikes});
   @override
  List<Object> get props => [allPostLikes!];

}
class StatusPostErrorState extends StatusPostState {
  final String? errorMessage;
  const StatusPostErrorState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage!];
}

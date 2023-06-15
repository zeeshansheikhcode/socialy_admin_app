import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';
import '../models/story_model.dart';

part 'status_post_state.dart';

class StatusPostCubit extends Cubit<StatusPostState> {
  StatusPostCubit() : super(StatusPostInitial());
  
  final List<StoryModel> _stories = [];
  List<StoryModel>   get stories => _stories; 
  final List<PostModel> _posts = [];
  List<PostModel>   get posts => _posts; 
  final List<Comment> _comments = [];
  List<Comment>   get comments => _comments; 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> allEmails =[];
  final List<List<StoryModel>> allStories = [];
  List<String> uniqueEmail =[];
  File? _imageFile;
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> pickImage({required isStatus}) async {
    emit(StatusPostLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
       try {
        final filePath = pickedFile.path;
        final lastIndex = filePath.lastIndexOf( RegExp(r'.jpg'));
        final splitted = filePath.substring(0, (lastIndex));
        final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
        var result1 = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path, outPath,
         quality: 10,
       );
      _imageFile = File(result1!.path);
      isLoading = true;
      _uploadImage(isStatus);
    } catch (e) {
      // Handle the compression error
      print('Image compression error: ${e.toString()}');
      // Show an error message or perform other actions as needed
    }
    }
  }

  Future<void> _uploadImage(bool isStatus) async {
    if (_imageFile == null) return;
    try {
      if(isStatus)
      {
      final imageName = DateTime.now().microsecondsSinceEpoch.toString();
      final storageReference = FirebaseStorage.instance.ref().child('userstories/$imageName');
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      await _firestore.collection('stories')
          .doc()
          .set(
            {
              "userId"     : _auth.currentUser!.uid,
              "useremail"  : _auth.currentUser!.email,
              "type"       :  "photo",
              "statusText" :  "No Text",
              "photoUrl"   :  downloadUrl,
              "likes"      : []
            }
          );
     isLoading = false;
     getStoriePosts();
      }
    else 
    { final String postid = const Uuid().v1();
      final imageName = DateTime.now().microsecondsSinceEpoch.toString();
      final storageReference = FirebaseStorage.instance.ref().child('userspost/$imageName');
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      await _firestore.collection('posts')
          .doc(postid)
          .set(
            {
              "userId"     : _auth.currentUser!.uid,
              "useremail"  : _auth.currentUser!.email,
              "type"       :  "photo",
              "photoUrl"   :  downloadUrl,
              "postId"     :  postid,
              "likes"      : []
            }
          );
     isLoading = false;
     getStoriePosts();
     }
    } catch (e) {
      emit(StatusPostErrorState(e.toString()));
    }
  }
 //Upload Status
  void uploadStatus(String statusText) async 
  {
    
    try 
    { 
       emit(StatusPostLoadingState());
      final  SharedPreferences prefs = await SharedPreferences.getInstance();
      await _firestore.collection('stories')
          .doc()
          .set(
            {
              "userId"     : _auth.currentUser!.uid,
              "useremail"  : _auth.currentUser!.email,
              "type"       :  "text",
              "statusText" :  statusText,
              "photoUrl"   :  "No Url",
              "profilePic" : prefs.getString('profilePic'),
              "dateTime"   : DateTime.now(),
              "username"   : prefs.getString('username'),
            }
          );
     getStoriePosts();
     
    }
    catch(e)
    {
      emit(StatusPostErrorState(e.toString()));
    }
  }
  deletePosts(PostModel postModel) async
  {  
    Reference storageReference = FirebaseStorage.instance.refFromURL(postModel.photoUrl!);
    storageReference.delete();
     await _firestore.collection('posts')
          .doc(postModel.postId)
          .delete();
    getStoriePosts();
  } 
 
  // Getting Stories
  void getStoriePosts() async
  {
    emit(StatusPostLoadingState());
     allStories.clear();
     allEmails.clear();
     uniqueEmail.clear();
     stories.clear();
     _posts.clear();
     
    final  CollectionReference activeStories =  _firestore.collection('stories');
    QuerySnapshot querySnapshot = await activeStories.get();
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Timestamp timestamp = doc['dateTime'];
    DateTime dateTime = timestamp.toDate();
     _stories.add(
        StoryModel(
        userId: doc['userId'],
        useremail: doc['useremail'],
        type: doc['type'],
        statusText: doc['statusText'] ?? 'No Status title',
        photoUrl: doc['photoUrl'] ?? 'No Photo Url', 
        dateTime: dateTime,
        profilePic: doc['profilePic'],
        username: doc['username'],
        ),
      );
      allEmails.add(doc['useremail']);
    }
    uniqueEmail = allEmails.toSet().toList();
    _stories.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
   for(int i=0; i <uniqueEmail.length; i++)
    {   final List<StoryModel> userStories = [];
        for(int j=0 ;j < stories.length; j++)
       {
         if(uniqueEmail[i] == stories[j].useremail.toString())
         { 
            userStories.add(stories[j]);
            print('$userStories');
         }
       } 
       allStories.add(userStories);
     }
     _stories.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
  
     
       final  CollectionReference activePosts =  _firestore.collection('posts');
    QuerySnapshot querySnapshotPost = await activePosts.get();
    for (DocumentSnapshot doc in querySnapshotPost.docs) {
     _posts.add(
        PostModel(
        userId: doc['userId'],
        useremail: doc['useremail'],
        type: doc['type'],
        photoUrl: doc['photoUrl'] ?? 'No Photo Url',
        postId: doc['postId'],
        likes: doc['likes'],
        ),
      );
    }
      print(_posts);
      emit(StatusPostLoadedState(allStories:allStories, allPost: _posts));
    }
  //  getPostsAndStories()
  //  {
  //   emit(StatusPostLoadingState());
  //   getStories();
  //   getPosts();
    
  //  }
//    getStories() async 
//    {
//    emit(StatusLoadingState());
//   allStories.clear();
//   allEmails.clear();
//   uniqueEmail.clear();
//   final CollectionReference activeStories = _firestore.collection('stories');
//   QuerySnapshot querySnapshot = await activeStories.get();

//   for (DocumentSnapshot doc in querySnapshot.docs) {
//     Timestamp timestamp = doc['dateTime'];
//     DateTime dateTime = timestamp.toDate();

//     _stories.add(
//       StoryModel(
//         userId: doc['userId'],
//         useremail: doc['useremail'],
//         type: doc['type'],
//         statusText: doc['statusText'] ?? 'No Status title',
//         photoUrl: doc['photoUrl'] ?? 'No Photo Url',
//         dateTime: dateTime,
//         profilePic: doc['profilePic'],
//         username: doc['username'],
//       ),
//     );

//     allEmails.add(doc['useremail']);
//   }

//   uniqueEmail = allEmails.toSet().toList();
//   _stories.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

//   for (int i = 0; i < uniqueEmail.length; i++) {
//     final List<StoryModel> userStories = [];

//     for (int j = 0; j < _stories.length; j++) {
//       if (uniqueEmail[i] == _stories[j].useremail.toString()) {
//         userStories.add(_stories[j]);
//       }
//     }

//     allStories.add(userStories);
//   }
//   emit(StatusLoadedState(allStories: allStories));
// }

//     getPosts() async
//     {  emit(PostLoadingState());
//       _posts.clear();
//       print('in post');
//        final  CollectionReference activePosts =  _firestore.collection('posts');
//     QuerySnapshot querySnapshotPost = await activePosts.get();
//     for (DocumentSnapshot doc in querySnapshotPost.docs) {
//      _posts.add(
//         PostModel(
//         userId: doc['userId'],
//         useremail: doc['useremail'],
//         type: doc['type'],
//         photoUrl: doc['photoUrl'] ?? 'No Photo Url',
//         postId: doc['postId'],
//         likes: doc['likes'],
//         ),
//       );
//     }
//       print(_posts);
//       await Future.delayed(const Duration(milliseconds: 500));
//       emit(PostLoadedState(allPost: _posts));
//     }

    
    likeAdded(PostModel postModel) async
    { 
      await _firestore.collection('posts')
          .doc(postModel.postId)
          .update(
            {
              "likes"   :  FieldValue.arrayUnion([_auth.currentUser!.uid]),
            }
          );
      final newPostModel = 
      await _firestore.collection('posts')
           .doc(postModel.postId)
           .get();
      
       final latestModel = PostModel(
        userId: newPostModel['userId'],
        useremail: newPostModel['username'],
        photoUrl: newPostModel['photoUrl'],
        type: newPostModel['type'], 
        postId: newPostModel['postId'],
        likes: newPostModel['likes']);
      emit(LikesLoadedState(allPostLikes: latestModel));
      getStoriePosts();
    }


    ///
    onSendComment(PostModel postModel,String commentText) async
    {
      try 
      {    
        final  SharedPreferences prefs = await SharedPreferences.getInstance();
        final String commetId = const Uuid().v1();
        final Comment sendComment =    Comment(
                       comment: commentText,
                       likes: 0,
                       commentId: commetId,
                       postId: postModel.postId!,
                       username: prefs.getString('username')!,
                       dateTime: DateTime.now(),
                       profilePic: prefs.getString('profilePic')!,
                  );
           await _firestore.collection('posts')
            .doc(postModel.postId)
            .collection('comments')
            .doc(commetId)
            .set({
               "comment"      : sendComment.comment,
               "likes"        : sendComment.likes,
                "commentId"   : sendComment.commentId,
                "postId"      : sendComment.postId,
                "username"    : sendComment.username,
                "dateTime"    : sendComment.dateTime,
                "profilePic"  : sendComment.profilePic
             });
         getComments(postModel);
      } 
      catch(e)
      {
        emit(StatusPostErrorState(e.toString()));
      }
    }
 ///
    getComments(PostModel postModel) async
    {
      _comments.clear();
    final  CollectionReference activeComments =  _firestore.collection('posts').doc(postModel.postId).collection('comments');
    QuerySnapshot querySnapshotPost = await activeComments.get();
    for (DocumentSnapshot doc in querySnapshotPost.docs) {
      Timestamp timestamp = doc['dateTime'];
    DateTime dateTime = timestamp.toDate();
     _comments.add(
        Comment(
        comment:     doc['comment'], 
        commentId:   doc['commentId'],
        postId:      doc['postId'],
        likes:       doc['likes'],
        dateTime   : dateTime,
        profilePic : doc['profilePic'],
        username   : doc['username'],
        ),
      );
    }
    _comments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    emit(CommentsLoadedState(allComments: _comments));
    }

}

  



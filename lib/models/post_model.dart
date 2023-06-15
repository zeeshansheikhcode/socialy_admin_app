
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel 
{
  final String? userId;
  final String? useremail;
  final String? type;
  final String? photoUrl;
  final String? postId;
  final List? likes;
  final List<Comment>? comments;
  PostModel({
   required this.userId,
   required this.useremail,
   required this.photoUrl,
   required this.type,
   required this.postId,
   required this.likes,
    this.comments,
    });

  Map<String, dynamic> toJson() {
    return {
      'userId'     : userId,
      'useremail'  : useremail,
      'type'       : type, 
      'photoUrl'   : photoUrl,
      'postId'     : postId,
      'likes'      : likes
     };
  }

 static PostModel fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId      : json['userId'] ,
      useremail   : json['useremail'],
      type        : json['type'],
      photoUrl    : json['photoUrl'], 
      postId      : json['postId'],
      likes       : json['likes'],   
    );
  }
}

class Comment{

  final String username;
  final String comment;
  final int likes;
  final String profilePic;
  final String commentId;
  final String postId;
  final DateTime dateTime;

  Comment({
    required this.username,
    required this.comment,
    required this.likes,
    required this.profilePic,
    required this.commentId,
    required this.postId,
    required this.dateTime,
});


  Map<String, dynamic> toJson()=>{
    'username' : username,
    'comment' : comment,
    'likes' : likes,
    'profilePic' : profilePic,
    'postId' : postId,
    'commentId' : commentId,
    'dateTime' : dateTime,
  };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
       username : snapshot['username'],
       comment : snapshot['comment'],
        dateTime : snapshot['dateTime'],
        likes : snapshot['likes'],
        profilePic : snapshot['profilePic'],
        commentId : snapshot['commentId'],
        postId : snapshot['postId'],
    );
  }
}

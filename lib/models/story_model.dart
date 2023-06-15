
class StoryModel 
{
  final String? userId;
  final String? useremail;
  final String? statusText;
  final String? type;
  final String? photoUrl;
  final String? username;
  final String? profilePic;
  final DateTime? dateTime;
  StoryModel({
   required this.userId,
   required this.useremail,
   required this.username,
   required this.profilePic,
   required this.dateTime,
    this.statusText,
    this.photoUrl,
   required this.type,
    });

  Map<String, dynamic> toJson() {
    return {
      'userId'     : userId,
      'useremail'  : useremail,
      'type'       : type, 
      'statusText' : statusText,
      'photoUrl'   : photoUrl,
      'profilePic' : profilePic,
      'username'   : username,
      'dateTime'   : dateTime,
     };
  }

 static StoryModel fromJson(Map<String, dynamic> json) {
    return StoryModel(
      userId      : json['userId'] ,
      useremail   : json['useremail'],
      type        : json['type'],
      statusText  : json['statusText'],
      photoUrl    : json['photoUrl'], 
      dateTime    : json['dateTime'],
      profilePic  : json['profilePic'],
      username    : json['username']     
    );
  }
}
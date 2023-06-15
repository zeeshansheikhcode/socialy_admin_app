import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserLoadingState());
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String? userName = '';
  final String? userPhotoUrl = '';
  File? _imageFile;
  final picker = ImagePicker();

  getUserInfo() async
  {
    emit(UserLoadingState());
    final userInfo   = await _firestore
                       .collection('Users')
                       .doc(_auth.currentUser!.uid)
                       .get()
                       .then((value) {
                       return UserModel(
                        userId: value.data()!['userId'], 
                        useremail: value.data()!['email'],
                        name: value.data()!['username'],
                        photoUrl: value.data()!['profilePic'],
                        followers: value.data()!['followers']
                        );
                       });  
    emit(UserLoadedState(userModel: userInfo));           
  
  }
  changeName(String name) async
  {
    emit(UserLoadingState());
               
                   await _firestore.collection('Users')
                   .doc(_auth.currentUser!.uid)
                   .update({
                       "username": name,      
                    });
    final userInfo   = await _firestore
                       .collection('Users')
                       .doc(_auth.currentUser!.uid)
                       .get()
                       .then((value) {
                       return UserModel(
                        userId: value.data()!['userId'], 
                        useremail: value.data()!['email'],
                        name: value.data()!['username'],
                        photoUrl: value.data()!['photoUrl'],
                        followers: value.data()!['followers']
                        );
                       });  
    emit(UserLoadedState(userModel: userInfo));
  
  }
 
  Future<void> pickImage() async {
    
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
   
      _uploadImage();
    } catch (e) {
      // Handle the compression error
      print('Image compression error: ${e.toString()}');
      // Show an error message or perform other actions as needed
    }
    }
  }
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    try {
      {
      final storageReference = FirebaseStorage.instance.ref().child('userimages/${_auth.currentUser!.uid}');
      await storageReference.putFile(_imageFile!);
      final downloadUrl = await storageReference.getDownloadURL();
      await _firestore.collection('Users')
          .doc(_auth.currentUser!.uid)
          .update(
            {
              "photoUrl"   :  downloadUrl,
            }
          );
        getUserInfo();
      }
      }
      catch(e)
      {
        emit(UserErrorState(e.toString()));
      }}

    
    addFollowers(String email) async
    {
       final result =  await _firestore.collection('Users')
                   .doc(_auth.currentUser!.uid)
                   .update({
                       "followers": FieldValue.arrayUnion([email]),      
                    });     
    }
    deleteFollowers(String email) async
    {
     final result =  await _firestore.collection('Users')
                   .doc(_auth.currentUser!.uid)
                   .update({
                       "followers": FieldValue.arrayRemove([email]),      
                    });
     getUserInfo();
 
    }
}
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

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoadingState());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? message ;
  String? picUrl = 'No Pic';
  File? userImage;
  final picker = ImagePicker();
  Future<void> uploadProfilePic() async
  {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
       try {
        
         print('inside');
        final filePath = pickedFile.path;
        final lastIndex = filePath.lastIndexOf( RegExp(r'.jpg'));
        final splitted = filePath.substring(0, (lastIndex));
        final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
        var result1 = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path, outPath,
         quality: 10,
       );
       userImage = File(result1!.path);
       final String profileId = const Uuid().v1();
       final imageName = profileId;
      final storageReference = FirebaseStorage.instance.ref().child('adminphotos/$imageName');
      await storageReference.putFile(userImage!);
      picUrl = await storageReference.getDownloadURL();
      print('picUrl $picUrl');
       }
      catch(e) 
      {
        emit(AuthErrorState(e.toString()));
      }
  }
  }
   Future<dynamic> signInWithEmailAndPassword( String email, String password) async 
   {
    try 
    {  
        emit(AuthLoadingState());
        final user = await _auth.signInWithEmailAndPassword(
         email: email,
         password: password,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final useremail   = await _firestore
                       .collection('Admins')
                       .doc(user.user!.uid)
                       .get()
                       .then((value) {
                       return [
                        value.data()!['email'],
                        value.data()!['username'],
                        value.data()!['profilePic'],
                        value.data()!['userId'],
                       ];
                       });               
        prefs.setString('email'    ,  useremail[0]);
        prefs.setString('username' ,  useremail[1]);
        prefs.setString('profilePic', useremail[2]);
        prefs.setString('userId',     useremail[3]);
      emit(const AuthLoadedState(true));
    } 
    on FirebaseAuthException catch (e) 
    {

        switch(e.code)
     {
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
       message = 'Wrong password';
       break;
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
       message = 'No user found with this email.';
       break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
       message ='User disabled.';
       break;
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
       message = 'Error too many request';
       break;
      case "ERROR_OPERATION_NOT_ALLOWED":
       message = 'Server error, please try again later.';
       break;
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
       message = 'Email address is invalid.';
       break;
      default:
       message = 'Login failed. Please try again.';
        } 
      emit(AuthErrorState(message!));     
    }
  }


   Future<dynamic> registerNewUser(String email,  String password,String username) async {
    try {
      emit(AuthLoadingState());
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
       );
       _firestore.collection('Admins')
        .doc(user.user!.uid)
        .set(
          {
             "email"       : email,
             "password"    : password,
             "userId"      : user.user!.uid,
             "username"    : username,
             "profilePic"  : picUrl,
             "followers"   : []
          }
        );
     SharedPreferences prefs = await SharedPreferences.getInstance();               
     prefs.setString('email'    , email);
     prefs.setString('username' , username);
     prefs.setString('profilePic', picUrl!);
     prefs.setString('userId',     user.user!.uid);
     emit(const AuthLoadedState(true));
     
    } 
    on FirebaseAuthException catch (e)
     {
       switch(e.code)
        {
          case "ERROR_EMAIL_ALREADY_IN_USE":
          case "account-exists-with-different-credential":
          case "email-already-in-use":
          message ='Email already used. Go to login page.';
          break;
          case "ERROR_USER_DISABLED":
          case "user-disabled":
          message ='User disabled.';
          break;
          case "ERROR_TOO_MANY_REQUESTS":
          case "operation-not-allowed":
          message = 'Too many requests to log into this account.';
          break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          message = 'Server error, please try again later.';
          break;
          case "ERROR_INVALID_EMAIL":
          case "invalid-email":
          message = 'Email address is invalid.';
          break;
          default:
          message = 'Sign Up Failed';
        }      
      emit(AuthErrorState(message!));
    }
  }


  // Future<dynamic> signInWithFacebook() async { 
  //    try {
  //        final LoginResult loginResult = await FacebookAuth.instance.login();
  //       final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //       final userCredential =await  FirebaseAuth.instance.signInWithCredential(facebookAuthCredential); 

  //        var user = userCredential.user;
  //        _firestore.collection('Users')
  //         .doc(user!.uid)
  //         .set(
  //           {
  //              "email"    : user.email,
  //              "password" : 'Facebook Account',
            

  //           }
  //         );
  //      SharedPreferences prefs = await SharedPreferences.getInstance();               
  //      prefs.setString('Email'    , user.email!);  
  //      return true;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         return false;
  //         // handle the error here
  //       }
  //       else if (e.code == 'invalid-credential') {
  //         return false;
  //         // handle the error here
  //       }
  //     } catch (e) {
  //       return false;
  //       // handle the error here
  //        }
  // // Once signed in, return the UserCredential
  //        return true;
  //  }
 
  //  Future<dynamic> signInWithGoogle({required BuildContext context}) async {
   
  //   User? user;

  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(credential);

  //         user = userCredential.user;
  //        _firestore.collection('Users')
  //         .doc(user!.uid)
  //         .set(
  //           {
  //              "email"    : user.email,
  //              "password" : 'Google Account',
            

  //           }
  //         );
  //      SharedPreferences prefs = await SharedPreferences.getInstance();               
  //      prefs.setString('Email'    , user.email!);  
  //      return true;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // handle the error here
  //       }
  //       else if (e.code == 'invalid-credential') {
  //         // handle the error here
  //       }
  //     } catch (e) {
  //       // handle the error here
  //     }
  //   }

  //   return user;
  // }   
  


 

  //  Future<dynamic> forgotPassword(String email) async {
  //   try {
  //     final result =  await  _auth.sendPasswordResetEmail(
  //     email    : email,
  //     );
  //     return true;
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
  Future<bool> logOut() async {
    try {

      await _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return true;
    } catch (e) {
        e.toString();
        return false;
    }
  }

}

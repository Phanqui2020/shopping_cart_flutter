import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/sqlite/user_db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/common/common_ulti.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommonUlti commonUlti = CommonUlti();
  final UserDb _userDb = UserDb();

  ///  create user based on UserCredential

  // UserModel? _getUserFromCredential(UserCredential userCredential){
  //   User? user = userCredential.user;
  //   return user != null ? UserModel(user.uid, userCredential.user!.email, userCredential.user!.n) : null;
  // }

  ///  auth change user stream
  // Stream<UserModel?> get user {
  //   return _auth.authStateChanges().listen((User user) {
  //     if(user == null){
  //       return null;
  //     }else{
  //       return _getUserFromCredential(userCredential);
  //     }
  //   })
  // }

  /// sign in anonymous
  // Future signInAnonymous() async{
  //   try{
  //     UserCredential user = await _auth.signInAnonymously();
  //     return _getUserFromCredential(user);
  //
  //   }catch(e) {
  //     print(e.toString());
  //     return null;
  //
  //   }
  // }
  /// sign in with email, password
  Future signIn(String email, String password) async {
     return await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
            CollectionReference col = FirebaseFirestore.instance
         .collection('user')
                .withConverter<UserModel>(
                fromFirestore: ((snapshot, options) =>
              UserModel.fromMap(snapshot.data()!)),
                toFirestore: (user,_) => user.toMap());
            return col.doc(userCredential.user!.uid).get();
       });
  }

  /// register with email, password
  Future<void> signUp(String email, String password, String username, XFile image) async {
    String fileName = image.name;
    File filePath = File(image.path);
    Reference storageRef = FirebaseStorage.instance.ref().child('avatar_image/$fileName');
    UploadTask uploadTask = storageRef.putFile(filePath);
    await uploadTask.whenComplete(() async{
      await uploadTask.snapshot.ref.getDownloadURL().then((value) async {
        // sign up
        await _auth.createUserWithEmailAndPassword(email: email, password: password)
            .then((userCredential) => {
          postDetailUser(username, email, value, userCredential.user!.uid)
        }).catchError((error){
          var errorMessage = error.message;
          commonUlti.showToast(errorMessage);
        });
      });

    }).catchError((error, stackTrace) {
    commonUlti.showToast(error.toString());
    });
  }

  /// post all user info to firebase
  Future<void> postDetailUser(String username, String email, String image, String uid) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try{
      UserModel userModel = UserModel(uid: uid,email: email, name: username, image: image);
      await fireStore
          .collection("user")
          .doc(uid)
          .set(userModel.toMap())
          .then((value) => {
            commonUlti.showToast("sign up success!")
          });
    }catch (errorMessage){
      commonUlti.showToast(errorMessage.toString());
    }
  }

  // sign out

}
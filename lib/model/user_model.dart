import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? image;

  UserModel({this.uid, this.email, this.name, this.image});


  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      image: map['image'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    print("---- factoring user ----");
    return UserModel(
      uid: doc.get('uid') ?? '',
      email: doc.get('email') ?? '',
      name: doc.get('name') ?? '',
      image: doc.get('image') ?? '',
    );
  }

}
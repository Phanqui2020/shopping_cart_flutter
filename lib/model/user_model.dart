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


}
import 'dart:io';

import 'package:demo/common/common_ulti.dart';
import 'package:demo/model/cart_model.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/sqlite/user_db_helper.dart';
import 'package:demo/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../sqlite/cart_db_helper.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final CommonUlti commonUlti = CommonUlti();
  final UserDb _userDb = UserDb();
  final CartDB _cartDB = CartDB();
  XFile? avatar;
  File? avatarPath;
  String? avatarName;
  final String avatarImg = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  Future getFromGallery() async {
    try{
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = File(image.path);
        setState(() {
          avatar = image;
          avatarPath = imageFile;
          avatarName = image.name;
        });
      }
      return null;
    }on PlatformException catch (e){
      commonUlti.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userDb.getUser(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 10.0,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70.0,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        child: GestureDetector(
                          child: snapshot != null ? Image.network(snapshot.data!.image.toString(),width: 300,  height: 300, fit: BoxFit.fill,)
                              : Image.network(avatarImg,fit: BoxFit.cover,),
                          onTap: (){
                            getFromGallery();
                          },
                        ),
                        borderRadius: BorderRadius.circular(70.0),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      const Text("Hi! ", style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                      Text(snapshot.data!.name.toString(),
                          style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      ]
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "User Information",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Card(
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      ...ListTile.divideTiles(
                                        color: Colors.red,
                                        tiles: [
                                          ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            leading: const Icon(Icons.account_circle_sharp, size: 40,),
                                            title: const Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),),
                                            subtitle: Text(snapshot.data!.name.toString(), style: const TextStyle( fontSize: 16)),
                                            onTap: (){ },
                                            iconColor: Colors.redAccent,
                                          ),
                                          ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            leading: const Icon(Icons.email_outlined, size: 40,),
                                            title: const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, )),
                                            subtitle: Text(snapshot.data!.email.toString(), style: const TextStyle( fontSize: 16)),
                                            iconColor: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 50.0,
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: const Text(
                                "Update",
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 50.0,

                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.grey,
                              onPressed: () {
                                _userDb.deleteUserByUid(snapshot.data!.uid.toString()).then((value){
                                  _cartDB.deleteAllProduct().then((value) {
                                    commonUlti.showToast("Log out successful!");
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginPage()));
                                  });
                                }).onError((error, stackTrace) {
                                  commonUlti.showToast(error.toString());
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              child: const Text(
                                "Log Out",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ];
        }
        return Center(
          child: Column(
            children: children,
          ),
        );
      },

    );
  }
}


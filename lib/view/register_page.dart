import 'dart:io';

import 'package:demo/common/common_ulti.dart';
import 'package:demo/provider/user_provider.dart';
import 'package:demo/view/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo/service/auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final UserProvider _userProvider = UserProvider();
  final CommonUlti commonUlti = CommonUlti();
  final _formKey = GlobalKey<FormState>();
  bool _showConfirmPass = true;
  bool _showPass = true;
  XFile? avatar;
  File? avatarPath;
  String? avatarName;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final AuthService _authService = AuthService();
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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white38,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/background.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  <Widget>[
                CircleAvatar(
                  radius: 70.0,
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    child: GestureDetector(
                      child: avatar != null ? Image.file(avatarPath!, width: 300,  height: 300, fit: BoxFit.fill,)
                                            : Image.network(avatarImg,fit: BoxFit.cover,),
                      onTap: (){
                        getFromGallery();
                      },
                    ),
                    borderRadius: BorderRadius.circular(70.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                UserNameWidget(userName),
                const SizedBox(height: 20.0),
                EmailWidget(email),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: password,
                  obscureText: _showPass,
                  validator: (value){
                    RegExp regex = RegExp(r'^.{6,}$');
                    if(value!.isEmpty){
                      return ("Please enter the password");
                    }
                    if(!regex.hasMatch(value)){
                      return ("Please enter the valid password at least 6 letters");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: _showPass?
                    IconButton(
                      onPressed: showPassword,
                      icon: const Icon(CupertinoIcons.eye, color: Colors.lightBlue),
                    )
                    :IconButton(
                      onPressed: showPassword,
                      icon: const Icon(CupertinoIcons.eye_fill),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(210.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: confirmPassword,
                  obscureText: _showConfirmPass,
                  validator: (value){
                    RegExp regex = RegExp(r'^.{6,}$');
                    if(value!.isEmpty || password.text != value || !regex.hasMatch(value)){
                      return ("doesn't match with password");
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: _showConfirmPass?
                    IconButton(
                      onPressed: showConfirmPassword,
                      icon: const Icon(CupertinoIcons.eye,color: Colors.lightBlue),
                    )
                    :IconButton(
                      onPressed: showConfirmPassword,
                      icon: const Icon(CupertinoIcons.eye_fill),
                    ),
                    prefixIcon: const Icon(Icons.lock,color: Colors.blue,),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(210.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _authService.signUp(email.text, password.text, userName.text, avatar!);
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginPage()));
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: const Text(
                      "Sign Up",
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have account?"),
                    GestureDetector(
                      onTap: (){
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginPage()));
                      },
                      child: const Text(
                        " Sign In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPassword() {
    setState(() {
      _showPass = !_showPass;
    });
  }
  void showConfirmPassword() {
    setState(() {
      _showConfirmPass = !_showConfirmPass;
    });
  }
}

/// Password
class PasswordWidget extends StatefulWidget {
  TextEditingController password;
  bool _showPass = true;

  PasswordWidget(this.password, {Key? key}) : super(key: key);

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.password,
      obscureText: widget._showPass,
      validator: (value){
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return ("Please enter the password");
        }
        if(!regex.hasMatch(value)){
          return ("Please enter the valid password at least 6 letters");
        }
      },
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon:
        widget._showPass?
        IconButton(
          onPressed: showPass(),
          icon: const Icon(
              CupertinoIcons.eye,
              color: Colors.lightBlue
          ),
        )
            :IconButton(
          onPressed: showPass(),
          icon: const Icon(
            CupertinoIcons.eye_fill,
          ),
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.blue,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(210.0),
        ),
      ),
    );
  }

  showPass() {
    widget._showPass = !widget._showPass;
  }
}

/// Confirm password

class ConfirmPasswordWidget extends StatefulWidget {
  TextEditingController confirmPassword;
  bool _showPass = true;

  ConfirmPasswordWidget(this.confirmPassword, {Key? key}) : super(key: key);

  @override
  _ConfirmPasswordWidgetState createState() => _ConfirmPasswordWidgetState();
}

class _ConfirmPasswordWidgetState extends State<ConfirmPasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.confirmPassword,
      obscureText: widget._showPass,
      validator: (value){
        RegExp regex = RegExp(r'^.{6,}$');
        if(value!.length < 3){
          return ("Please enter the valid password at least 6 letters");
        }
      },
      decoration: InputDecoration(
        hintText: "Confirm Password",
        suffixIcon:
        widget._showPass?
        IconButton(
          onPressed: showPass(),
          icon: const Icon(
              CupertinoIcons.eye,
              color: Colors.lightBlue
          ),
        )
            :IconButton(
          onPressed: showPass(),
          icon: const Icon(
            CupertinoIcons.eye_fill,
          ),
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.blue,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(210.0),
        ),
      ),
    );
  }

  showPass() {
    widget._showPass = !widget._showPass;
  }
}

/// Email

class EmailWidget extends StatefulWidget {
  var email;
  EmailWidget(this.email, {Key? key}) : super(key: key);

  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.email,
          validator: (value){
            RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
            if(value!.isEmpty){
              return ("Please enter the email");
            }
            if(!regex.hasMatch(value)){
              return ("Please enter the valid email");
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: const Icon(
              Icons.email,
              color: Colors.blue,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 5.0),
              borderRadius: BorderRadius.circular(210.0),
            ),
          ),
        ),
      ],
    );
  }
}

/// UserName

class UserNameWidget extends StatefulWidget {
  var username;
  UserNameWidget(this.username, {Key? key}) : super(key: key);

  @override
  _UserNameWidgetState createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.username,
          validator: (value){
            RegExp regex = RegExp(r'^.{6,}$');
            if(value!.isEmpty){
              return ("Please enter the username");
            }
            if(value.length < 3){
              return ("Please enter the valid username at least 3 letters");
            }
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "User Name",
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 5.0),
              borderRadius: BorderRadius.circular(210.0),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:demo/common/common_ulti.dart';
import 'package:demo/model/user_model.dart';
import 'package:demo/sqlite/user_db_helper.dart';
import 'package:demo/view/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo/service/auth.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as ins;
import 'package:demo/common/button_tapped.dart';
import 'package:demo/common/button.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final UserDb userDb = UserDb();
  final CommonUlti commonUlti = CommonUlti();
  // bool isPressed = true;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService _authService = AuthService();
  final CommonUlti _commonUlti = CommonUlti();

  @override
  Widget build(BuildContext context) {
    // Offset distance = isPressed? Offset(, 10) : Offset(10, 10);
    // double blur  = isPressed ? 5.0 : 30.0;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        // color: const Color(0xFFE7ECEF),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: const Image(
                    image: AssetImage("assets/images/logo.png"),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text("Welcome!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.redAccent),),
                const SizedBox(height: 20.0),
                EmailWidget(username),
                const SizedBox(height: 20.0),
                PasswordWidget(password),
                const SizedBox(height: 20.0),
                // GestureDetector(
                //   onTap: () => setState(() {
                //     isPressed = !isPressed;
                //   }),
                //   child: AnimatedContainer(
                //     duration: Duration(milliseconds: 100),
                //     child: SizedBox(height: 70, width: 70,),
                //       decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(30),
                //             boxShadow: [
                //               ins.BoxShadow(
                //                 blurRadius: blur,
                //                 offset: -distance,
                //                 color: Colors.white,
                //                 inset: true,
                //               ),
                //               ins.BoxShadow(
                //                 inset: true,
                //                 blurRadius: blur,
                //                 offset: distance,
                //                 color: Color(0xFFA7A9AF),
                //               ),
                //         ])
                //   ),
                // ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _authService.signIn(username.text, password.text)
                            .then((value) {
                              userDb.insert(UserModel.fromFirestore(value))
                              .then((value) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomePage()));
                                commonUlti.showToast("Login successful!");
                              })
                              .onError((error, stackTrace) {
                                commonUlti.showToast("An error has been occurred, Please try again");
                               });
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    child: const Text(
                      "Login",
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const RegisterPage()));
                      },
                      child: const Text(
                          " Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// const PasswordWidget({Key? key, required this.password}) : super(key: key);

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
        return null;
      },
      decoration: InputDecoration(
        suffixIcon:
        widget._showPass?
        IconButton(
          onPressed: showPass,
          icon: const Icon(
              CupertinoIcons.eye,
              color: Colors.lightBlue
          ),
        )
            :IconButton(
          onPressed: showPass,
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

  void showPass() {
    setState(() {
      widget._showPass = !widget._showPass;
    });
  }
}


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
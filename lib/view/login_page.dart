import 'package:demo/model/user_model.dart';
import 'package:demo/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo/service/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService _authService = AuthService();

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
                    image: AssetImage("assets/images/logo.jpg"),
                  ),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                EmailWidget(username),
                const SizedBox(height: 20.0),
                PasswordWidget(password),
                const SizedBox(height: 20.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _authService.signIn(username.text, password.text);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
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
                //const SizedBox(height: 20.0),
                // Container(
                //   height: 50.0,
                //   width: double.infinity,
                //   child: RaisedButton(
                //     color: Colors.blueGrey,
                //     onPressed: () async {
                //      //UserModel result = await _authService.signInAnonymous();
                //      // if(result == null){
                //      //   print("error login");
                //      // }else{
                //      //   print(result.uid);
                //      // }
                //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
                //     },
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30.0)
                //     ),
                //     child: const Text(
                //       "login Anonymous",
                //     ),
                //   ),
                // ),
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
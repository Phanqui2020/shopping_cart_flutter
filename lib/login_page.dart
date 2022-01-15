import 'package:demo/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Image(
                  image: AssetImage("assets/images/logo.jpg"),
                ),
              ),
              const SizedBox(height: 10.0),
              const SizedBox(height: 10.0),
              UserWidget(username),
              const SizedBox(height: 10.0),
              PasswordWidget(password),
              const SizedBox(height: 10.0),
              Container(
                height: 50.0,
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomePage()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: const Text(
                    "Login",
                  ),
                ),
              ),
            ],
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
    return TextField(
      controller: widget.password,
      obscureText: widget._showPass,
      decoration: InputDecoration(
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


class UserWidget extends StatefulWidget {
  var username;
  UserWidget(this.username, {Key? key}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.username,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
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
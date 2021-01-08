import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/components/alertbox.dart';
import 'package:ecommerce_int2/components/loader.dart';
import 'package:ecommerce_int2/screens/auth/forgot_password_page.dart';
import 'package:ecommerce_int2/screens/main/main_page.dart';
import 'package:ecommerce_int2/services/userService.dart';
import 'package:ecommerce_int2/services/validateService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'register_page.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final userRef = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  HashMap userValues = new HashMap<String, String>();
  bool _autoValidate = false;

  ValidateService _validateService = ValidateService();
  UserService _userService = UserService();

  login() async {
    //loginfunction will be invoked when user will be provide their correct passwprd and email
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);

      await _userService.login(userValues);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = _userService.statusCode;

      if (statusCode == 200) {
        Get.off(MainPage());
        Get.snackbar(
            "Welcome", "You are successfully login shop new gifts 20 % off",
            duration: Duration(seconds: 7),
            colorText: Colors.white,
            backgroundColor: Colors.pink,
            isDismissible: true);
      } else {
        AlertBox alertBox = AlertBox(_userService.msg);
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertBox.build(context);
            });
      }
    } else {
      print("not  validate...................");

      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'Welcome Back in Gitanjali shop,',
      style: GoogleFonts.zillaSlab(
          textStyle: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text('Login to your account using\nEmail & password',
            style: GoogleFonts.pangolin(
                textStyle: TextStyle(fontSize: 15, color: Colors.white))));

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          login();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: new Text("Log In",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 32.0, right: 12.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      controller: email,
                      style: TextStyle(fontSize: 16.0),
                      validator: (value) =>
                          _validateService.isEmptyField(value),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String val) {
                        userValues['email'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(hintText: "Password"),
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                      validator: (value) =>
                          _validateService.isEmptyField(value),
                      onSaved: (String val) {
                        userValues['password'] = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget register = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don"t have an Account ? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(RegisterPage());
            },
            child: Text(
              'Register ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ForgotPasswordPage());
            },
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/intro2.png'), fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                welcomeBack,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                register,
                loginForm,
                Spacer(flex: 2),
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  }
}

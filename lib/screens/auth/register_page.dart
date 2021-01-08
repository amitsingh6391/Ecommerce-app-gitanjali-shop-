import 'dart:async';
import 'dart:collection';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/components/alertbox.dart';
import 'package:ecommerce_int2/components/loader.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/services/userService.dart';
import 'package:ecommerce_int2/services/validateService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _autoValidate = false;
  double borderWidth = 1.0;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ValidateService validateService = ValidateService();
  UserService userService = UserService();
  BuildContext scaffoldContext;

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController name = TextEditingController();
  HashMap userValues = new HashMap<String, String>();

  signup() async {
    //when user fill their details when he press on signup
    if (this._formKey.currentState.validate()) {
      //this function will be invoke.
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);
      await userService.signup(userValues);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = userService.statusCode;

      print(statusCode);
      if (statusCode == 400) {
        //we check statuscode which will be return from firebase
        AlertBox alertBox = AlertBox(
            userService.msg); //according to status code we will show diffrent
        return showDialog(
            //msg . if statuscode==200 means everything is right and
            context:
                context, //we show them msg your account is successfully created
            builder: (BuildContext context) {
              //otherwise we will display them message whatever
              return alertBox.build(context); //return from firebase.
            });
      } else {
        print(statusCode);

        Get.to(WelcomeBackPage());
        Get.snackbar(
            "success", "Your Account is Successfully Created  Login Now",
            duration: Duration(seconds: 4),
            colorText: Colors.white,
            backgroundColor: Colors.pink,
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true);

        Get.to(WelcomeBackPage());
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'You are at right place',
      style: GoogleFonts.zillaSlab(
          textStyle: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Create your new account and start shoping now.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          signup();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
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

    Widget registerForm = Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              height: 220,
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          validateService.validateEmail(value),
                      onSaved: (String val) {
                        userValues['email'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(hintText: "password"),
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                      validator: (value) =>
                          validateService.validatePassword(value),
                      onSaved: (String val) {
                        userValues['password'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: name,
                      style: TextStyle(fontSize: 16.0),
                      validator: (value) => validateService.isEmptyField(value),
                      onSaved: (String val) {
                        userValues['name'] = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                title,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                Padding(
                    padding: EdgeInsets.only(bottom: 20), child: socialRegister)
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

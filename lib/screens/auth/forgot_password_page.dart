import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';
import 'package:ecommerce_int2/services/validateService.dart';

import 'confirm_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();

  GlobalKey prefixKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  double prefixWidth = 0;
  UserService userService = UserService();

  ValidateService _validateService = ValidateService();
  @override
  Widget build(BuildContext context) {
    Widget background = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
      ),
      foregroundDecoration: BoxDecoration(color: transparentYellow),
    );

    Widget title = Text(
      'Forgot your Password?',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Enter your registered Email to get the reset link',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget sendButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          if (this._formKey.currentState.validate()) {
            userService.resetpassword(email.text);
            Get.snackbar(
                "success", "A  password reset link is sent on your mail",
                duration: Duration(seconds: 5),
                colorText: Colors.white,
                backgroundColor: Colors.pink,
                isDismissible: true);
          } else {
            Get.snackbar("Error", "Please write valid mail id",
                duration: Duration(seconds: 3),
                colorText: Colors.white,
                backgroundColor: Colors.pinkAccent,
                snackPosition: SnackPosition.BOTTOM,
                isDismissible: true);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: new Text("Verify",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.pinkAccent,
                  ],
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

    Widget phoneForm = Container(
      height: 180,
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 30),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        controller: email,
                        style: TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(hintText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            _validateService.validateEmail(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          sendButton,
        ],
      ),
    );

    Widget resendAgainText = Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Didn't receive the Link? ",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14.0,
              ),
            ),
            InkWell(
              onTap: () {
                userService.resetpassword(email.text);
              },
              child: Text(
                'Resend again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ));
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://opendoodles.s3-us-west-1.amazonaws.com/swinging.png'),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(color: transparentYellow),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 2),
                      phoneForm,
                      Spacer(flex: 2),
                      resendAgainText
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

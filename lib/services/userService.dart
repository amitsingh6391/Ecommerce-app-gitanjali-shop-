import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/models/user.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  //we are define useservice class inside class we will define
  FirebaseAuth _auth =
      FirebaseAuth.instance; //our whole methods ,which will be used in later.
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String sharedKey = 'sharedKey';
  int statusCode;
  String msg;
  Myuser currentUserDetails;
  SharedPreferences sharedPreferences;

  void logOut(context) async {
    sharedPreferences =
        await SharedPreferences.getInstance(); //their token  number

    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<void> login(userValues) async {
    String email = userValues[
        'email']; //inside our app for this method we need 2 parameters taht
    String password = userValues['password']; //are email and password.

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((dynamic user) async {
      //if the user is successfully login then we will
      //save their details in locally by using share prefer....
      User currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser.uid;
      print("****************$uid");

      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      currentUserDetails = Myuser.fromDocument(doc);
      // sharedPreferences = await SharedPreferences.getInstance();
      // sharedPreferences.setString("userId", currentUserDetails.id);

      statusCode =
          200; //and at the end we will assign statuscode =200 because user login is successfull
    }).catchError((error) {
      handleAuthErrors(
          error); //or in case of any error we will handel that by using try and catch
    }); //this handleautherros() function will be invoked if any kind off errors occurs
  }

  Future<void> resetpassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signup(userValues) async {
    String email = userValues['email'];
    String password = userValues[
        'password']; //and the same thing we nee 2 parameters at a time of signup

    print("signup proccess");
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: email,
              password: password) //after signup we will store their
          .then((dynamic user) {
        //information in backend.
        String uid = user.user.uid;
        _firestore.collection('users').doc(uid).set({
          'Name': capitalizeName(userValues['name']),
          'email': userValues['email'],
          'id': uid,
          'createdAt': DateTime.now(),
          "location": "55,78",
          "dob": "12/13/2000",
          "phone": "6391345357",
          "gender": "male",
          "picture": "abcdeh\\nmjbh"
        });

        print("signup ");

        statusCode = 200;
      });
    } catch (error) {
      handleAuthErrors(error);
    }
  }

  void handleAuthErrors(error) {
    print("error");

    String errorCode = error.code;
    print("******************$errorCode");
    //insdie this function we are check diffrent possible error case
    switch (errorCode) {
      //according to them we will assing statuscode
      case "email-already-in-use":
        {
          statusCode = 400;
          msg = "Email ID already existed";
          print("yesss");
        }
        break;
      case "too-many-requests":
        {
          statusCode = 400;
          msg = "Please try after some time you cross your max. attempt";
          print("yesss");
        }
        break;

      case "user-not-found":
        {
          statusCode = 400;
          msg = "User not found";
          print("yesss");
        }
        break;

      case "invalid-email":
        {
          statusCode = 400;
          msg = "Invalid - Email";
          print("yesss");
        }
        break;
      case "wrong-password":
        {
          print("yesss");
          statusCode = 400;
          msg = "Password is wrong";
        }
    }
  }

  String capitalizeName(String name) {
    //this function will hepls us  to captializename when user did
    name = name[0].toUpperCase() + name.substring(1); //not to that.
    return name;
  }

  Future<String> userEmail() async {
    User user = FirebaseAuth.instance.currentUser;
    // var user = await _auth.currentUser();
    return user.email;
  }
}

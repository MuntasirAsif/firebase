
import 'dart:async';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices{
  void isLogin(BuildContext context){
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user == null) {
      Timer(
          const Duration(seconds: 4),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
    else{
      Timer(
          const Duration(seconds: 4),
              () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScrren())));
    }
  }
}
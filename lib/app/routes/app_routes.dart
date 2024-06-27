import 'package:flutter/material.dart';
import 'package:youtube/meta/views/authentication/login_screen.dart';
import 'package:youtube/meta/views/authentication/signup_screen.dart';
import 'package:youtube/screens/home_screen.dart';
import 'package:youtube/screens/profile_screen.dart';

class AppRoutes {
  static const String loginRoute = "/login";
  static const String signUpRoute = "/signUp";
  static const String homeRoute = "/home";
  static const String profileRoute = "/profile";

  static final Map<String, WidgetBuilder> routes = {
    loginRoute: (context) => LoginScreen(),
    signUpRoute: (context) => SignupScreen(),
    homeRoute: (context) => HomeScreen(),
    profileRoute: (context) => const ProfileScreen(),
  };
}

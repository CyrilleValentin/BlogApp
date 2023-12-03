import 'package:blog_app/authentification/login.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/authentification/register.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return _materialRoute(const Onboard());
      case loginRoute:
        return _materialRoute( const LoginPage());
      case registerRoute:
        return _materialRoute( const RegisterPage());

      default:
        return _materialRoute(const Onboard());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
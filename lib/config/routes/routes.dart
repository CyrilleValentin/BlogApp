import 'package:blog_app/authentification/login.dart';
import 'package:blog_app/authentification/register.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return _materialRoute(const HomePage());
      case loginRoute:
        return _materialRoute( const LoginPage());
      case registerRoute:
        return _materialRoute( RegisterPage());

      default:
        return _materialRoute(const HomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
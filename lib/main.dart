
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/config/routes/routes.dart';
import 'package:blog_app/pages/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
      home:Splashscreen() ,
    );
  }
}

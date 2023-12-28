import 'package:blog_app/config/routes/routes.dart';
import 'package:blog_app/pages/splash_screen.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await dotenv.load(fileName: ".env");
  runApp(const BlogApp());
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: SplashScreen(),
    );
  }
}

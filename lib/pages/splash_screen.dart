// ignore_for_file: use_build_context_synchronously
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/pages/home_page.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final pref = Preferences.pref;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _buildHomeWidget(),
    );
  }

  Widget _buildHomeWidget() {
    if (pref.getLogin == true) {
      return const HomePage(isDark: false,); // L'utilisateur est connecté, affichez la page de sélection de la difficulté
    }
    if (pref.getLogout == false) {
      return const Onboard(); // L'utilisateur n'est pas connecté, affichez la page d'accueil
    }
    // Si ni connecté ni déconnecté, vous pouvez renvoyer un widget par défaut, par exemple Accueil
    return const Onboard();
  }
}

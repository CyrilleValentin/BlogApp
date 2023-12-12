// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/api/requete.dart';
import 'package:blog_app/authentification/register.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/pages/home_page.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isPasswordVisible = false;
  bool loading = false;
  final pref = Preferences.pref;

  void loginUser() async {
    ResponseApi response = await login(email.text, password.text);
    if (response.error == null) {
      savedRediction(response.data as User);
       pref.login();
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void savedRediction(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    navigatorDelete(context, const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            "Connexion",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF165081),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: const Text(
                            strLogin1,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF165081),
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: myInput(
                              hintText: 'Email',
                              icon: Icons.email,
                              controller: email,
                              validator: (value) {
                                if (value == "") {
                                  return emailHint;
                                }
                                if (!emailRegex.hasMatch(value!)) {
                                  return emailVerifHint;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: myInput(
                              hintText: 'Mot de passe',
                              icon: Icons.password,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Change l'icône en fonction de la visibilité du mot de passe
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  // Change l'état pour montrer/cacher le mot de passe
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              controller: password,
                              validator: (value) {
                                if (value == "") {
                                  return passwordHint;
                                }
                                if (!passwordRegex.hasMatch(value!)) {
                                  return password8CaractHint;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: MaterialButton(
                            minWidth: 120,
                            height: 40,
                            onPressed: () {
                              _submitForm();
                            },
                            color: const Color(0xFF165081),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(strLogin2),
                          GestureDetector(
                            onTap: () {
                              navigatorSimple(context, const RegisterPage());
                            },
                            child: const Text(
                              "S'inscrire",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
        loginUser();
      });
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/api/api_user.dart';
import 'package:blog_app/authentification/login.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/pages/home_page.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  final pref = Preferences.pref;
  bool _isPasswordVisible = false;
  bool loading = false;
  registerUser() async {
    ResponseApi response = await register(name.text, email.text, password.text);
    if (response.error == null) {
      savedRediction(response.data as User);
      pref.login();
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void savedRediction(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    navigatorDelete(context, const DarkSample());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Inscription",
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
                          strRegister1,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF165081),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: myInput(
                          hintText: 'Nom',
                          icon: Icons.person,
                          controller: name,
                          validator: (value) {
                            if (value == "") {
                              return nameHint;
                            }
                            return null;
                          },
                        )),
                    const SizedBox(
                      height: 20,
                    ),
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
                        )),
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
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
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
                            })),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: myInput(
                          hintText: 'Confirmer Mot de passe',
                          icon: Icons.password,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          controller: confpassword,
                          validator: (value) {
                            if (value == "") {
                              return confpasswordHint;
                            }
                            if (!passwordRegex.hasMatch(value!)) {
                              return confVerifpasswordHint;
                            }
                            return null;
                          },
                        )),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: MaterialButton(
                          minWidth: 150,
                          height: 40,
                          onPressed: () {
                            _submitForm();
                          },
                          color: const Color(0xFF165081),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        )),
                FadeInUp(
                    duration: const Duration(milliseconds: 1600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(strRegister2),
                        GestureDetector(
                          onTap: () {
                            navigatorSimple(context, const LoginPage());
                          },
                          child: const Text(
                            " Connexion",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
        registerUser();
      });
    }
  }
}

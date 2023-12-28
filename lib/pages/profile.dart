// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/api/api_user.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/user.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  User? user;
  bool loading = true;
  File? imageFile;
  final picker = ImagePicker();
  TextEditingController name = TextEditingController();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  Future<void> getuser() async {
    ResponseApi response = await getUser();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        name.text = user!.name ?? '';
      });
    } else if (response.error == unauthorised) {
      logout().then((value) => {navigatorDelete(context, const Onboard())});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
void updateProfile() async {
    ResponseApi response = await update(name.text,getStringImage(imageFile!));
     setState(() {
        loading = false;
      });
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorised) {
      logout().then((value) => {navigatorDelete(context, const Onboard())});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: imageFile == null
                            ? user!.image != null
                                ? DecorationImage(
                                    image: NetworkImage('${user!.image}'),
                                    fit: BoxFit.cover,
                                  )
                                : null
                            : DecorationImage(
                                image: FileImage(imageFile ?? File('')),
                                fit: BoxFit.cover,
                              ),
                        color: Colors.amber,
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formkey,
                  child: FadeInUp(
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
                ),
                const SizedBox(height: 20,),
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
                            "Modifier",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        )),
              ],
            ),
          );
  }
   void _submitForm() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
        
      });
      updateProfile();
    }
  }
}

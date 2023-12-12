import 'dart:io';

import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController post = TextEditingController();
  bool loading = false;
  File? imageFile;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau poste"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: imageFile == null
                          ? null
                          : DecorationImage(
                              image: FileImage(imageFile ?? File('')),
                              fit: BoxFit.cover)),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black26,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: myInput2(
                        maxLines: 9,
                        controller: post,
                        hintText: "Legende du poste",
                        validator: (value) {
                          if (value == "") {
                            return postHint;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text("Poster")),
                )
              ],
            ),
    );
  }

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:blog_app/api/api_post.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/authentification/login.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/posts.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  final Post? post;
  final String? title;
  const NewPostScreen({super.key,  
    this.post,
    this.title,
  });



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
  void creatPost()async{
    String? image = imageFile == null ? null : await getStringImage(imageFile!);
    ResponseApi response=await storePost(post.text,image);
    if (response.error==null){
      Navigator.of(context).pop();
    }
    else if(response.error==unauthorised){
      logout().then((value) => navigatorDelete(context, const LoginPage()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        loading=!loading;
      });
    }
  }

  void updatePost(int postId)async{
    ResponseApi response=await editPost(postId,post.text);
    if (response.error==null){
      Navigator.of(context).pop();
    }
    else if(response.error==unauthorised){
      logout().then((value) => navigatorDelete(context, const LoginPage()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        loading=!loading;
      });
    }
  }
  @override
  void initState() {
   if(widget.post!=null){
    post.text=widget.post!.body??'';
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("${widget.title}"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                widget.post!=null? const SizedBox():
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
      if(widget.post==null){
      creatPost();
      }else{
        updatePost(widget.post!.id ?? 0);
      }
    }
  }
}

import 'package:blog_app/api/api_post.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/posts.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  bool loading = true;
  int userId = 0;
  List<dynamic> _postList = [];

  Future<void> allUsers() async {
    userId = await getUserId();
    ResponseApi response = await getPost();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    } else if (response.error == unauthorised) {
      logout().then((value) => {navigatorDelete(context, const Onboard())});
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    allUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircleAvatar(),
          )
        : ListView.builder(
            itemCount: _postList.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _postList[index];
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
  }
}

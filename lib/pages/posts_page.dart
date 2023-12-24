import 'package:blog_app/api/api_post.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/posts.dart';
import 'package:blog_app/pages/comments_page.dart';
import 'package:blog_app/pages/new_post.dart';
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

  void _handlelikeUnlikePost(int postId) async {
    ResponseApi response = await likePost(postId);
    if (response.error == null) {
      allUsers();
    } else if (response.error == unauthorised) {
      logout().then((value) => {navigatorDelete(context, const Onboard())});
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
   void _handleDeletePost(int postId) async {
    ResponseApi response = await removePost(postId);
    if (response.error == null) {
      allUsers();
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
        : RefreshIndicator(
            onRefresh: () {
              return allUsers();
            },
            child: ListView.builder(
                itemCount: _postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _postList[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      image: post.user!.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  '${post.user!.image}'))
                                          : null,
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${post.user!.name}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            post.user!.id == userId
                                ? PopupMenuButton(
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Modifier'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Supprimer'),
                                      )
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        navigatorSimple(context, NewPostScreen(
                                          title: "Modifier un post",  
                                          post: post,
                                        ));
                                        
                                      } else {
                                        _handleDeletePost(post.id ?? 0);
                                      }
                                    },
                                  )
                                : const SizedBox(width: 1)
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('${post.body}'),
                        post.image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                padding: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        '${post.image}',
                                      ),
                                      fit: BoxFit.contain),
                                ),
                              )
                            : SizedBox(
                                height: post.image != null ? 0 : 10,
                              ),
                        Row(
                          children: [
                            likeComentBtn(
                                post.likesCount ?? 0,
                                post.selfLiked == true
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                post.selfLiked == true
                                    ? Colors.red
                                    : Colors.black54, () {
                              _handlelikeUnlikePost(post.id ?? 0);
                            }),
                            Container(
                              height: 25,
                              width: 0.5,
                              color: Colors.black38,
                            ),
                            likeComentBtn(post.commentsCount ?? 0,
                                Icons.sms_outlined, Colors.black54, () {
                                   navigatorSimple(context, CommentScreen(
                                          postId: post.id,
                                        ));
                                }),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.5,
                          color: Colors.black26,
                        )
                      ],
                    ),
                  );
                }),
          );
  }
}

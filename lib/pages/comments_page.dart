import 'package:blog_app/api/api_comment.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/authentification/login.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/components/input.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/models/comments.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;

  const CommentScreen({
    super.key,
    this.postId,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentaire = TextEditingController();
  List<dynamic> _commentList = [];
  bool loading = true;
  int userId = 0;
   int editCommentId=0;
  Future<void> _getComment() async {
    userId = await getUserId();
    ResponseApi response = await getComments(widget.postId ?? 0);
    if (response.error == null) {
      setState(() {
        _commentList = response.data as List<dynamic>;
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

  void _creatComment() async {
    ResponseApi response =
        await createComments(widget.postId ?? 0, commentaire.text);
    if (response.error == null) {
      commentaire.clear();
      _getComment();
    } else if (response.error == unauthorised) {
      logout().then((value) => navigatorDelete(context, const LoginPage()));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        loading = !loading;
      });
    }
  }

  void _editComment() async {
    ResponseApi response = await editComments(editCommentId, commentaire.text);
    if (response.error == null) {
      editCommentId = 0;
      commentaire.clear();
      _getComment();
    } else if (response.error == unauthorised) {
      logout().then((value) => navigatorDelete(context, const LoginPage()));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        loading = !loading;
      });
    }
  }

  void _deleteComment(int commentId) async {
    ResponseApi response = await removeComment(commentId);
    if (response.error == null) {
      _getComment();
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
    _getComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Commentaires"),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return _getComment();
                      },
                      child: ListView.builder(
                          itemCount: _commentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Comment comment = _commentList[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black26, width: 0.5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              image: comment.user!.image != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          '${comment.user!.image}'),
                                                      fit: BoxFit.cover)
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${comment.user!.name}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      comment.user!.id == userId
                                          ? PopupMenuButton(
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
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
                                                  setState(() {
                                                    editCommentId =
                                                        comment.id ?? 0;
                                                    commentaire.text =
                                                        comment.comment ?? '';
                                                  });
                                                } else {
                                                  _deleteComment(
                                                      comment.id ?? 0);
                                                }
                                              },
                                            )
                                          : const SizedBox(width: 1)
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text('${comment.comment}'),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black26, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: myInput(
                              controller: commentaire,
                              hintText: 'Commenter',
                              icon: Icons.comment_bank_outlined),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (commentaire.text.isNotEmpty) {
                              setState(() {
                                loading = true;
                              });
                              if (editCommentId > 0) {
                                _editComment();
                              } else {
                                _creatComment();
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }
}

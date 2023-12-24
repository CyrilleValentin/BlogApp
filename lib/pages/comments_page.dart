import 'package:blog_app/api/api_comment.dart';
import 'package:blog_app/api/api_response.dart';
import 'package:blog_app/authentification/onBoard/on_board.dart';
import 'package:blog_app/config/constants/constant.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;

const CommentScreen({super.key,  
    this.postId,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentList=[];
  bool loading = true;
  int userId=0;
   Future<void> getComment() async {
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
  @override
  void initState() {
    getComment();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Commentaires"),),
      
    );
  }
}
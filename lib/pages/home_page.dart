import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/pages/new_post.dart';
import 'package:blog_app/pages/posts_page.dart';
import 'package:blog_app/pages/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: currentIndex == 0 ? const PostsScreen() : const ProfileScreen(),
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        onPressed: () {
          navigatorSimple(context, const NewPostScreen(
            title: "Créer un post",
          ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}

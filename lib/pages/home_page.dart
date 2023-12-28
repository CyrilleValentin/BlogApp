import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:blog_app/config/darkmode.dart';
import 'package:blog_app/config/routes/navigator.dart';
import 'package:blog_app/pages/new_post.dart';
import 'package:blog_app/pages/posts_page.dart';
import 'package:blog_app/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   final Function()? onpress;
   final bool isDark;
  const HomePage({super.key, this.onpress, required this.isDark});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData appBarIcon = CupertinoIcons.moon_stars;

  void _incrementCounter() {
    widget.onpress!();
    setState(() {
      appBarIcon = widget.isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars;
    });
  }
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('Blog App'),
    backgroundColor: const Color(0xFF165081),
    elevation: 0,
    actions: [
      ThemeSwitcher(
        builder: (context) => IconButton(
          icon:  Icon(appBarIcon),
          onPressed: () {
            _incrementCounter();
           
          },
        ),
      ),
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


class DarkSample extends StatefulWidget {
  const DarkSample({super.key});

  @override
  _DarkSampleState createState() => _DarkSampleState();
}
class _DarkSampleState extends State<DarkSample> {
  bool isDark = false;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleOffset = Offset(size.width - 20, size.height - 20);
    return DarkTransition(
      childBuilder: (context, x) => HomePage(

        onpress: () {
          setState(() {
            isDark = !isDark;
          });
        },
         isDark: isDark,
      ),
      offset: circleOffset,
      isDark: isDark,
    );
  }
}

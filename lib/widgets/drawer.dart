import 'package:chatgpt_flutter/constants/constants.dart';
import 'package:chatgpt_flutter/screens/chat_screen.dart';
import 'package:chatgpt_flutter/screens/home_screen.dart';
import 'package:chatgpt_flutter/services/assets_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Image.asset(
                AssetsManager.dexfixBetaLogo,
                width: 50,
              ),
            ),
            DrawerItem(
                icon: const Icon(
                  CupertinoIcons.home,
                  color: Colors.white,
                ),
                text: "Home Page",
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false)),
            DrawerItem(
                icon: const Icon(
                  CupertinoIcons.search,
                  color: Colors.blue,
                ),
                text: "Ask DeFi",
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                    ),),
            DrawerItem(
                icon: const Icon(
                  CupertinoIcons.creditcard,
                  color: Colors.green,
                ),
                text: "Send Transaction",
                onTap: () => print("Send Transaction tapped")),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Icon icon;

  const DrawerItem(
      {Key? key, required this.text, required this.onTap, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }
}

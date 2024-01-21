import 'package:chatgpt_flutter/constants/constants.dart';
import 'package:chatgpt_flutter/screens/chat_screen.dart';
import 'package:chatgpt_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // Assuming you already have a dark theme
        Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "DeFi made easy",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white, // Adjust the color as needed
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Trade your favorite tokens instantly, interact with DeFi protocols, get market insights using our Dexﬁn AI",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white, // Adjust the color as needed
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen())),
              child: const CardWidget(
                icon: Icons.search,
                title: "Ask DeFi",
                desc:
                    "Explore the DeFi ecosystem and ﬁnd the resources that you need.",
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const CardWidget(
              icon: Icons.credit_card,
              title: "Send Transactions",
              desc:
                  "Swap tokens, send transactions, interact with protocols, and much more.",
              color: Colors.green,
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const CardWidget(
      {Key? key,
      required this.icon,
      required this.title,
      required this.desc,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      color: Colors.grey[800], // Adjust the color as needed
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(20)),
                  child: Icon(icon, size: 30, color: Colors.white),
                ), // Adjust the color as needed
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Adjust the color as needed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 18,

                color: Colors.white, // Adjust the color as needed
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

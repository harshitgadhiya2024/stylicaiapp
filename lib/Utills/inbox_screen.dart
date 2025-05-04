import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Inbox",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Get a Verified Profile fufdijd,eewuiewu, you're only missing three steps from having a",
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Image.asset(
                  "assets/images/blacklogo.png",
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20,),
                Icon(Icons.arrow_forward_ios_rounded, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/market/detailsDialogue.dart';

class ListCard extends StatelessWidget {
  ListCard({
    Key key,
    this.name,
    this.tag,
    this.chapterNumber,
    this.press,
  }) : super(key: key);
  final name;
  final tag;
  final chapterNumber;
  final press;

  var auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      margin: EdgeInsets.only(bottom: 16, left: 20, right: 20),
      width: size.width - 32,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(4, 3))
        ],
      ),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$chapterNumber : $name \n",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: tag,
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.more,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return DetailDialog(detailId: 'Flash', user: auth);
                }),
          )
        ],
      ),
    );
  }
}

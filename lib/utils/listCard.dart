import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/catalogue/detailForm.dart';
import 'package:naviget/market/detailsDialogue.dart';

// ignore: must_be_immutable
class ListCard extends StatelessWidget {
  ListCard({
    Key key,
    this.type,
    this.docId,
    this.name,
    this.tag,
    this.image,
    this.chapterNumber,
    this.press,
    this.val,
  }) : super(key: key);
  final type;
  final docId;
  final name;
  final tag;
  final chapterNumber;
  final press;
  final image;
  final val;

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
          image == null
              ? CircleAvatar(child: Text(chapterNumber.toString()))
              : InkWell(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              image,
                              color: Colors.white,
                              colorBlendMode: BlendMode.darken,
                              alignment: Alignment.topCenter,
                              fit: BoxFit.contain,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                          )),
                  child: CircleAvatar(
                    backgroundImage: image == null
                        ? null
                        : Image.network(
                            image,
                            color: Colors.white,
                            colorBlendMode: BlendMode.darken,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.contain,
                          ).image,
                  ),
                ),
          SizedBox(
            width: 12,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: " $name \n",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: tag.toString(),
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return type == 'pending'
                        ? DetailForm(detailId: docId, user: auth)
                        : DetailDialog(
                            val: val,
                          );
                  });
            },
          )
        ],
      ),
    );
  }
}

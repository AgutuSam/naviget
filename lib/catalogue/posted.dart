import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/utils/listCard.dart';

class Posted extends StatefulWidget {
  const Posted({Key key}) : super(key: key);

  @override
  _PostedState createState() => _PostedState();
}

class _PostedState extends State<Posted> {
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();
  var auth = FirebaseAuth.instance.currentUser;
  final CollectionReference mapDoc =
      FirebaseFirestore.instance.collection('Maps');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: mapDoc
            .where('User', isEqualTo: auth.uid)
            .where('mapState', isEqualTo: 'posted')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            List<DocumentSnapshot> data = snapshot.data.docs;
            return data.isEmpty
                ? BeautifulAlertDialog('There are no "posted" maps as of yet!')
                : Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.only(
                                top: size.height * .05,
                                left: size.width * .02,
                                right: size.width * .02),
                            height: size.height,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/bg.jpg"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Container()),
                        ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(data.length, (index) {
                            var val = data[index];
                            return ListCard(
                              name: val['mapName'],
                              tag: val['date'],
                              image: val['image'],
                              chapterNumber: index + 1,
                              docId: val.id,
                              type: 'posted',
                              val: val,
                              press: () {},
                            );
                          }),
                        ),
                      ],
                    ),
                  );
          }
        });
  }
}

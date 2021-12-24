import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/catalogue/testList.dart';
import 'package:naviget/market/detailsDialogue.dart';
import 'package:naviget/utils/listCard.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key key}) : super(key: key);

  @override
  _MarketListState createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  var auth = FirebaseAuth.instance.currentUser;
  final CollectionReference mapDoc =
      FirebaseFirestore.instance.collection('Maps');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                top: size.height * .15,
                left: size.width * .02,
                right: size.width * .02),
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/streets.jpg"),
                fit: BoxFit.cover,
              ),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(50),
              //   bottomRight: Radius.circular(50),
              // ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: mapDoc
                  .where('User', isNotEqualTo: auth.uid)
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
                      ? BeautifulAlertDialog(
                          'There are no lands in the market as of yet!')
                      : ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(data.length, (index) {
                            var val = data[index];
                            return ListCard(
                              name: val['mapName'],
                              tag: val['date'],
                              image: val['image'],
                              chapterNumber: index + 1,
                              docId: val.id,
                              type: 'market',
                              val: val,
                              press: () {},
                            );
                          }),
                        );
                }
              }),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/catalogue/testList.dart';
import 'package:naviget/market/detailsDialogue.dart';
import 'package:naviget/utils/listCard.dart';

class Bought extends StatefulWidget {
  const Bought({Key key}) : super(key: key);

  @override
  _BoughtState createState() => _BoughtState();
}

class _BoughtState extends State<Bought> {
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();

  var auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
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
          ListWheelScrollView(
            itemExtent: 85.0,
            controller: fixedExtentScrollController,
            physics: FixedExtentScrollPhysics(),
            children: List.generate(TestList.bought.length, (index) {
              var val = TestList.bought[index];
              return ListCard(
                  name: val.name,
                  tag: val.date.toString(),
                  chapterNumber: index,
                  press: () {
                    print('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
                    print('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
                    print('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG');
                    showDialog(
                        context: context,
                        builder: (context) =>
                            DetailDialog(detailId: 'Flash', user: auth));
                  });
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:naviget/catalogue/testList.dart';
import 'package:naviget/utils/listCard.dart';

class Pending extends StatefulWidget {
  const Pending({Key key}) : super(key: key);

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();
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
            physics: const FixedExtentScrollPhysics(),
            children: List.generate(TestList.pending.length, (index) {
              var val = TestList.pending[index];
              return ListCard(
                name: val.name,
                tag: val.date.toString(),
                chapterNumber: index,
                press: () {},
              );
            }),
          ),
        ],
      ),
    );
  }
}

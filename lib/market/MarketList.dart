import 'package:flutter/material.dart';
import 'package:naviget/catalogue/testList.dart';
import 'package:naviget/utils/listCard.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key key}) : super(key: key);

  @override
  _MarketListState createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    // top: size.height * .05,
                    left: size.width * .02,
                    right: size.width * .02),
                height: size.height * .9158,
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: size.height * .87,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    TestList.market.length,
                    (index) {
                      TestList val = TestList.market[index];
                      return ListCard(
                        name: val.name,
                        tag: val.date.toString(),
                        chapterNumber: index,
                        press: () {},
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

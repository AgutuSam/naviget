import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ItemDetail extends StatefulWidget {
  ItemDetail({this.detailId, this.user});
  final detailId;
  final user;

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final quantity = TextEditingController();

  User auser = FirebaseAuth.instance.currentUser;

  final CollectionReference detailDoc =
      FirebaseFirestore.instance.collection('Detail');
  final CollectionReference userDoc =
      FirebaseFirestore.instance.collection('users');

  var prodId;

  var unitState;

  var transactionId;

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  AnimationController animationController;

  TextEditingController amountController = TextEditingController();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static const TextStyle label = TextStyle(
    // h6 -> title
    // fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 14,
    letterSpacing: 0.18,
    color: Colors.orange,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: MediaQuery.of(context).viewInsets.bottom == 0
          ? Alignment.center
          : Alignment.topCenter,
      child: SizedBox(
        height: MediaQuery.of(context).viewInsets.bottom == 0
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height * 0.9,
        child: FutureBuilder(
            future: detailDoc
                .doc(widget.detailId)
                .get()
                .then((value) => value.data()),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FlareActor(
                        'assets/naviloading.flr',
                        animation: 'Aura',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              }
              Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    const Text(
                      'Map Name',
                      style: TextStyle(color: Colors.green),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          "Seller",
                          style: label,
                        ),
                        Text("John Doe", style: label)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(data['Contact']),
                        Text(data['johndoe@mailme.com']),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          "Address",
                          style: label,
                        ),
                        Text("Size", style: label)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(data['End of Karen Rd'] ?? ""),
                        SizedBox(width: 10),
                        Text(data['45 Ha'] ?? ""),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "State",
                              style: label,
                            ),
                            Text(
                              data["Pending"] ?? '',
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Price",
                              style: label,
                            ),
                            Text(
                              data["Kshs. 1,200,000"],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ]),
                ),
              );
            }),
      ),
    );
  }
}

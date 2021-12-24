import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class DetailDialog extends StatefulWidget {
  DetailDialog({this.detailId, this.user, this.val});
  final detailId;
  final user;
  final val;

  @override
  _DetailDialogState createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
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
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.3,
        child: FutureBuilder(
            future: detailDoc
                .doc(widget.detailId)
                .get()
                .then((value) => value.data()),
            builder: (BuildContext context, snapshot) {
              // if (!snapshot.hasData) {                                                 **SNAPSHOT
              if (snapshot.hasData) {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
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
              // Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;                                             **SNAPSHOT
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Text(
                      'Map Name: ' + widget.val['mapName'] ?? 'Map Name',
                      style: TextStyle(color: Colors.green),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Phone",
                          style: label,
                        ),
                        Text('Email', style: label)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Text(data['Contact']),                                                **SNAPSHOT
                        Text(widget.val['phone']),
                        // Text(data['johndoe@mailme.com']),                                                **SNAPSHOT
                        Text(widget.val['email']),
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
                        // Text(data['End of Karen Rd'] ?? ""),                                                **SNAPSHOT
                        Text(widget.val['address']),
                        SizedBox(width: 10),
                        // Text(data['45 Ha'] ?? ""),                                                **SNAPSHOT
                        Text(widget.val['size'] + widget.val['measure']),
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
                              // data["Pending"] ?? '',                                                **SNAPSHOT
                              widget.val['mapState'],
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
                              // data["Kshs. 1,200,000"],                                                **SNAPSHOT
                              'Kshs ' + widget.val['price'],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]),
                ),
              );
            }),
      ),
    );
  }
}
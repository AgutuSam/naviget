import 'dart:math';

import 'package:flutter/material.dart';
import 'package:naviget/shared/buddyShares.dart';
import 'package:naviget/shared/team.dart';

class BuddyView extends StatelessWidget {
  const BuddyView({
    Key key,
    this.teamMember,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final Team teamMember;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 12, bottom: 12),
              child: Card(
                margin: EdgeInsets.only(right: 12.0),
                color: Colors.white38,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0))),
                elevation: 2.5,
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Bud()));
                  },
                  child: SizedBox(
                    width: 280,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 16),
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                width: 48,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color: Color.fromARGB(1, 248, 250, 251),
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Text(
                                                  teamMember.name,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    letterSpacing: 0.27,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '...',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  0.27,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.8),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 16, right: 16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${teamMember.org}',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 2, top: 20),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(68.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      offset: const Offset(2, 2),
                                      blurRadius: 4),
                                ],
                              ),
                              // child: Image.network(uzer(uzzer).imagePath,
                              //     fit: BoxFit.cover),
                              child: Image.asset('assets/user.png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

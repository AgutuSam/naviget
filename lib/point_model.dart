import 'package:flutter/material.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/routeView.dart';
import 'package:naviget/shared/point.dart';

class ModelView extends StatelessWidget {
  const ModelView(
      {Key key,
      this.modell,
      this.auth,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Point modell;
  final BaseAuth auth;
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
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {},
              child: Card(
                elevation: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RouteView(
                                auth: auth,
                                buddyPoint: modell.marker,
                              ),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        margin: EdgeInsets.only(left: 4.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.5, color: Colors.black26))),
                        child: CircleAvatar(
                          // child: Image.asset(model.imagePath),
                          radius: 14.0,
                          backgroundColor: Colors.white,
                          child: Text(modell.name[0]),
                          // backgroundImage: Image.asset(model.imagePath).image,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                modell.name,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: modell.org,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

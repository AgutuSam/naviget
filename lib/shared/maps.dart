import 'package:flutter/material.dart';
import 'package:naviget/shared/team.dart';

class UniMaps extends StatefulWidget {
  const UniMaps({
    Key key,
  }) : super(key: key);

  @override
  _UniMapsState createState() => _UniMapsState();
}

class _UniMapsState extends State<UniMaps> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    // await ;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: !false,
        title: Text(
          'Shared',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF000050),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: Container(
                      child: Center(child: CircularProgressIndicator())),
                );
              } else {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List<Widget>.generate(
                        Team.teamList.length,
                        (int index) {
                          final int count = Team.teamList.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController.forward();
                          return ModelView(
                            callback: () {},
                            modell: Team.teamList[index],
                            animation: animation,
                            animationController: animationController,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ModelView extends StatelessWidget {
  const ModelView(
      {Key key,
      this.modell,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Team modell;
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
                      onTap: () {},
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
                            backgroundImage:
                                Image.asset('assets/prof.jpg').image
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
                                  fontSize: 24.0,
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

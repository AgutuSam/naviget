import 'package:flutter/material.dart';
import 'package:naviget/shared/buddyShares.dart';
import 'package:naviget/shared/buddyView.dart';
import 'package:naviget/shared/team.dart';

class BuddiesList extends StatefulWidget {
  const BuddiesList({
    Key key,
  }) : super(key: key);

  @override
  _BuddiesListState createState() => _BuddiesListState();
}

class _BuddiesListState extends State<BuddiesList>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: !false,
        title: Text(
          'Buddies',
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
                          return BuddyView(
                            teamMember: Team.teamList[index],
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

import 'package:flutter/material.dart';
import 'package:naviget/main.dart';

class PrimeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrimeDrawerState();
}

class _PrimeDrawerState extends State<PrimeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.orange.shade300,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 8.0)
                        ],
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.orange, Colors.orange])),
                    child: CircleAvatar(
                        radius: 44.5,
                        backgroundImage: AssetImage('assets/prof.jpg')),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Anonymous User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Anonym@naviget.com',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.orange.shade100,
                image: DecorationImage(
                    image: AssetImage('assets/atlas.jpg'), fit: BoxFit.cover)),
          ),
          SizedBox(height: 30.0),
          _buildRow(Icons.home, 'Home', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.account_circle, 'Profile', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.email, 'Contact us', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.star, 'Rate us', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.help_outline, 'Help', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.info_outline, 'Info', context, MyApp()),
          _buildDivider(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: .2),
            child: FlatButton(
              onPressed: () {},
              child: Row(children: [
                Icon(
                  Icons.power_settings_new,
                  color: Colors.orange.shade300,
                ),
                SizedBox(width: 10.0),
                Text(
                  'LogOut',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Spacer(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.deepOrangeAccent.shade200,
    );
  }

  Widget _buildRow(
      IconData icon, String title, BuildContext context, Widget route,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: Colors.black, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: .2),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
        child: Row(children: [
          Icon(
            icon,
            color: Colors.orange.shade300,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.deepOrange,
              elevation: 5.0,
              shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '10+',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }
}

// 오른쪽에있는 햄버거버튼

import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                child: Text('병해충'),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.grey[850],
              ),
              title: Text('지도'),
              onTap: () {
                Navigator.pushNamed(context, '/bug_map');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.description,
                color: Colors.grey[850],
              ),
              title: Text('농약'),
              onTap: () {
                Navigator.pushNamed(context, '/pesticide_page');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.equalizer,
                color: Colors.grey[850],
              ),
              title: Text('병해충'),
              onTap: () {
                Navigator.pushNamed(context, '/screens/home/home-screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}

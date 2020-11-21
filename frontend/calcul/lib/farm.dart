import 'package:calcul/top_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmPage extends StatefulWidget {
//  static const routName = '/farm';
  @override
  _FarmPageState createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
  @override
  Widget build(BuildContext context) {
    final Map country = ModalRoute.of(context).settings.arguments;

    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
          backgroundColor: Colors.lightGreen[200],
          appBar: AppBar(
//            title: Text('농약 정보', style: TextStyle(fontWeight: FontWeight.w400)),
//            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 82.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  Positioned(
                    top: 75.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height - 100.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    left: (MediaQuery.of(context).size.width / 2) - 100.0,
                    child: Hero(
                      tag: 'imageHero',
                      child: GestureDetector(
                        onTap: () {
                          launch(country['pesti_img']);
                        },
                        child: Image.network(
                          country['pesti_img'],
//                        fit: BoxFit.cover,
                          height: 200.0,
                          width: 200.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 250.0,
                    left: 25.0,
                    right: 25.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          country['pesti_name'],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(country['dis_name'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15.0,
                                    color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                            height: 100.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                _buildInfoCard('독성', country['toxic_name']),
                                SizedBox(width: 10.0),
                                _buildInfoCard('희석배수', country['dilutunit']),
                                SizedBox(width: 10.0),
                                _buildInfoCard('사용적기', country['pestiuse']),
                                SizedBox(width: 10.0),
                                _buildInfoCard(
                                    '안전사용기준(일수)', country['use_num']),
                                SizedBox(width: 10.0),
                                _buildInfoCard(
                                    '안전사용기준(횟수)', country['usesuit_time']),
                              ],
                            )),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                launch(
                                    'http://www.nongsaro.go.kr/portal/ps/psz/psza/contentMain.ps?menuId=PS04352');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        '농약허용기준강화제도',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: Image.asset(
                                            'images/korealogo.png',
                                            fit: BoxFit.cover,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                color: Colors.grey[400],
                                width: 1.0),
                            GestureDetector(
                              onTap: () {
                                launch(
                                    'http://www.foodsafetykorea.go.kr/residue/main.do');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        '잔류농약데이터베이스',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: Image.asset(
                                            'images/korealogo.png',
                                            fit: BoxFit.cover,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 30.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                launch(
                                    'http://pes.nongsaro.go.kr/pls/plsMain.ps');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        '농약판매관리인',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: Image.asset(
                                            'images/korealogo.png',
                                            fit: BoxFit.cover,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                color: Colors.grey[400],
                                width: 1.0),
                            GestureDetector(
                              onTap: () {
                                launch('http://psis.rda.go.kr/psis/index.do');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        '농약안전정보시스템',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(
                                        child: Image.asset(
                                            'images/korealogo.png',
                                            fit: BoxFit.cover,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          endDrawer: MyDrawer()),
    );
  }
}

Widget _buildInfoCard(String cardTitle, String info) {
  return InkWell(
      onTap: () {},
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                color: Colors.green, style: BorderStyle.solid, width: 0.75),
          ),
          height: 100.0,
          width: 120.0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Text(cardTitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        color: Colors.blue.withOpacity(0.7),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(info,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ])));
}

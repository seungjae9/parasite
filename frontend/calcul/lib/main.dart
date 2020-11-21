import 'package:calcul/CustomShapeClipper.dart';
import 'package:calcul/bug_map.dart';
import 'package:calcul/farm.dart';
import 'package:calcul/pest-details-screen.dart';
import 'package:calcul/pesticide_page.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:calcul/home-screen.dart';

void main() {
  runApp(new ControlleApp());
}

class ControlleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App",
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/farm': (context) => FarmPage(),
        '/bug_map': (context) => MapScreen(),
        '/pesticide_page': (context) => PesticidePage(),
        '/screens/home/home-screen': (context) => HomeScreen(),
//        '/pest_detail': (context) => PestDetailScreen(),
//        '/screens/pest/pest_detail': (context) => PestDetailScreen()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          HomeScreenTopPart(),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          HomeScreenBottomPart(),
        ],
      ),
//        drawer: MyDrawer());
    );
  }
}


class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: screenSize.height * 0.75,
            color: Colors.lightGreen[200],
          child: Column(
            children: <Widget>[
              SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
//                    Icon(Icons.bubble_chart, color: Colors.white,),
//                    SizedBox(width: 16.0,),
//                    Text('asdfasdf'),
                    Spacer(),
                    Icon(Icons.settings, color: Colors.white,)
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Text('병해충 죽여버렷', style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 50.0,),
              Image.asset('images/farmer.png', height: 350,)
            ],
          ),
          ),
        ),
      ],
    );
  }
}


class HomeScreenBottomPart extends StatefulWidget {
  @override
  _HomeScreenBottomPartState createState() => _HomeScreenBottomPartState();
}

class _HomeScreenBottomPartState extends State<HomeScreenBottomPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: menuButtons,
        shrinkWrap: true,
      ),
    );
  }
}

List<MenuButton> menuButtons = [
  MenuButton("images/bugmap.png", "지도", "/bug_map"),
  MenuButton("images/virus.png", "병해충", "/screens/home/home-screen"),
  MenuButton("images/bugg.png", "농약", "/pesticide_page")
];

class MenuButton extends StatelessWidget {
  final String imagePath, buttonName, tapName;

  MenuButton(this.imagePath, this.buttonName, this.tapName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {Navigator.pushNamed(context, tapName);},
              child: Container(
                height: 150,
                width: 120,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              height: 50,
              width: 160,
              child: Container(
//                color: Colors.black,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.05)
                    ])),
              ),
            ),
            Positioned(
              right: 35.0,
              bottom: 7.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 1.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(
                  buttonName,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

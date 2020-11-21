import 'package:calcul/top_drawer.dart';
import 'package:flutter/material.dart';
import 'package:calcul/components/app_bar.dart';
import 'package:calcul/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      resizeToAvoidBottomInset : false,
      body: Body(),
      endDrawer: MyDrawer(),
    );
  }
}
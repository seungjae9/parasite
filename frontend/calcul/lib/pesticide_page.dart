import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:dio/dio.dart';

class PesticidePage extends StatefulWidget {
  @override
  _PesticidePageState createState() => _PesticidePageState();
}

class _PesticidePageState extends State<PesticidePage> {
//  final TextEditingController _filter = TextEditingController();
//  FocusNode focusNode = FocusNode();
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;

  getCountries() async {
    var response = await Dio().get('http://k02c1021.p.ssafy.io/pages/datas4');
    return response.data;
  }

  @override
  void initState() {
    getCountries().then((data) {
      setState(() {
        countries = filteredCountries = data;
      });
    });
    super.initState();
  }

  void _filterCountries(value) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
          country['pesti_name2'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: SafeArea(
//        minimum: EdgeInsets.only(top: 50.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen[200],
            elevation: 0.0,
            title: !isSearching
                ? Text('검색')
                : TextField(
              onChanged: (value) {
                _filterCountries(value);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "이름을 입력해주세요",

                  hintStyle: TextStyle(color: Colors.white)),
            ),
            actions: <Widget>[
              isSearching
                  ? IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    this.isSearching = false;
                    filteredCountries = countries;
                  });
                },
              )
                  : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this.isSearching = true;
                  });
                },
              )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.all(10),
                      child: filteredCountries.length > 0
                          ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: filteredCountries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/farm',
                                    arguments: filteredCountries[index]);
                              },
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  child: Text(
                                    filteredCountries[index]['pesti_name2'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          })
                          : Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Container(
                  child: Center(
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      color: Colors.white,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Mydialog();
                            });
                      },
                      child: Text(
                        '농약 계산기',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Colors.lightGreen[200],
        ),
      ),
    );
  }
}

class Mydialog extends StatefulWidget {
  @override
  _MydialogState createState() => _MydialogState();
}

class _MydialogState extends State<Mydialog> {
  var Result = "";
  TextEditingController pescontroll = TextEditingController();
  TextEditingController ratiocontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: pescontroll,
            decoration: InputDecoration(labelText: "농약량(ml,g)을 입력해주세요"),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: ratiocontroll,
            decoration: InputDecoration(labelText: "비율(배수)을 입력해주세요"),
          ),
          new Text(
            '물 양: $Result(L)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            textAlign: TextAlign.center,
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            '계산하기',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              double pes = double.parse(pescontroll.text);
              double ratio = double.parse(ratiocontroll.text);

              var temp = (pes * ratio) / 1000;
              Result = temp.toString();
            });
          },
        )
      ],
    );
  }
}

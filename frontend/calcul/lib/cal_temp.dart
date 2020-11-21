//var tipResult = "";
//TextEditingController controller = new TextEditingController();
//TextEditingController tipController = new TextEditingController();
//
//
//
//Center(
//child: Theme(
//data: new ThemeData(
//primaryColor: Colors.green,
//textTheme: TextTheme()
//),
//child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//new Padding(
//padding: EdgeInsets.all(15.0),
//child: new TextField(
//keyboardType: TextInputType.number,
//decoration: InputDecoration(
//labelText: '농약',
//hintText: '농약을 입력하세요',
//prefixIcon: Icon(Icons.attach_money),
//border: OutlineInputBorder(
//borderRadius: BorderRadius.all(
//Radius.circular(25.0)))),
//
//controller: controller,
//),
//),
//new Padding(
//padding: EdgeInsets.all(15.0),
//child: new TextField(
//keyboardType: TextInputType.number,
//decoration: InputDecoration(
//labelText: '비율',
//hintText: '비율을 입력하세요',
//prefixIcon: Icon(Icons.show_chart),
//border: OutlineInputBorder(
//borderRadius: BorderRadius.all(
//Radius.circular(25.0)))),
//controller: tipController,
//),
//),
//new Text('비율: $tipResult', style: TextStyle(fontWeight: FontWeight.bold))
//],
//),
//),
//)
//
//
//
//
//floatingActionButton: FloatingActionButton(
//onPressed: _tipCalc,
//tooltip: 'tip calc',
//child: Text('계산')
//),
//
//
//
//
//
//
//
//void _tipCalc() {
//  if (controller.text.length == 0) {
//    return;
//  }
//  if (tipController.text.length == 0) {
//    return;
//  }
//
//  setState(() {
//    int money = int.parse(controller.text);
//    int tip = int.parse(tipController.text);
//    print(money);
//    print(tip);
//
//    var result = money + (money * (tip / 100));
//    print((money * (tip / 100)));
//    tipResult = result.toString();
//  });
//}
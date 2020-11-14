import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController =
      TextEditingController(text: '5, 6, 3, 7, 8, 9, 4, 4, 2, 5, 5, 9, 3');

  List<int> toIntList(String data) =>
      data.split(',').map((item) => int.parse(item)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              controller: myController,
            ),
          ),
          FlatButton(
              color: Colors.amber,
              onPressed: () => setState(() {
                    //myController.clear();
                    var txt = toIntList(myController.text).toString();
                    myController.text = txt.substring(1, txt.length - 1);
                    FocusScope.of(context).requestFocus(FocusNode());
                  }),
              child: Text('Go')),
          //Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProporcionalLayout(data: toIntList(myController.text)),
            ),
          ),
          //Divider(),
        ],
      ),
    );
  }
}

class ProporcionalLayout extends StatelessWidget {
  ProporcionalLayout({
    Key key,
    var this.data,
  }) : super(key: key);

  var data = <int>[];

  dynamic _reparto(List<int> data) {
    var listas = [<int>[], <int>[]];
    // ====== sort y uno a uno
    data
      ..sort()
      ..reversed;

    // ====== reparto de uno a uno
    // for (var i = 0, j = 0; i < data.length; i++) {
    //   j = (j + 1) % 2;
    //   listas[j].add(data[i]);
    // }

    // ==== reparto equilbrado
    // for (var i = 0, j = 0; i < data.length; i++) {
    //   var j = _val(listas[0]) < _val(listas[1]) ? 0 : 1;
    //   listas[j].add(data[i]);
    // }

    // ==== reparto equilbrado y afin(iguales en la misma lista)
    var prevj = -1;
    var j = 0;
    for (var i = 0; i < data.length; i++) {
      if (prevj >= 0 && data[i] == listas[prevj].last)
        j = prevj;
      else
        j = _val(listas[0]) < _val(listas[1]) ? 0 : 1;
      listas[j].add(data[i]);
      prevj = j;
    }
    if (listas[1].length < 1) listas[1].add(listas[0].removeLast());
    if (listas[0].length < 1) listas[0].add(listas[1].removeLast());

    // ===== return ======
    return listas;
  }

  int _val(List<int> data) =>
      data.fold(0, (previousValue, element) => previousValue + element).toInt();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (data.length == 1)
        return MiCaja(
            txt:
                '${data[0]}\n${constraints.maxWidth.toInt()} x ${constraints.maxHeight.toInt()}\n${(constraints.maxWidth * constraints.maxHeight).toInt()}');
      var listas = _reparto(data);

      if (constraints.maxWidth > constraints.maxHeight) {
        return Row(children: [
          Expanded(
              flex: _val(listas[0]),
              child: ProporcionalLayout(data: listas[0])),
          Expanded(
            flex: _val(listas[1]),
            child: ProporcionalLayout(data: listas[1]),
          )
        ]);
      }
      return Column(children: [
        Expanded(
          flex: _val(listas[0]),
          child: ProporcionalLayout(data: listas[0]),
        ),
        Expanded(
          flex: _val(listas[1]),
          child: ProporcionalLayout(data: listas[1]),
        )
      ]);
    });
  }
}

class MiCaja extends StatelessWidget {
  const MiCaja({
    Key key,
    @required this.txt,
  }) : super(key: key);

  final String txt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 2, 0, 0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        border: Border.all(
            color: Colors.blueGrey[200], //                   <--- border color
            width: 1.0),
        //color: Colors.blue,

        borderRadius: BorderRadius.all(
            Radius.circular(2.0) //                 <--- border radius here
            ),
      ),
      child: Center(child: Text(txt, textAlign: TextAlign.center)),
    );
  }
}

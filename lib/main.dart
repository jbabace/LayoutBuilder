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
          // ===========  FORMULARIO DE LA LISTA =========
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              controller: myController,
            ),
          ),
          FlatButton(
              color: Colors.amber[400],
              onPressed: () => setState(() {
                    //myController.clear();
                    var txt = toIntList(myController.text).toString();
                    myController.text = txt.substring(1, txt.length - 1);
                    FocusScope.of(context).requestFocus(FocusNode());
                  }),
              child: Text('Go', style: TextStyle(color: Colors.white))),
          //Divider(),
          // ==============  LA LISTA =============
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutRecursivo(data: toIntList(myController.text)),
            ),
          ),
          //Divider(),
        ],
      ),
    );
  }
}

class LayoutRecursivo extends StatelessWidget {
  LayoutRecursivo({
    Key key,
    var this.data,
  }) : super(key: key);

  var data = <int>[];

  List<List<int>> _repartirItems(List<int> inList) {
    var outList = [<int>[], <int>[]];
    // ====== ordenamos
    inList..sort((b, a) => a.compareTo(b));
    //..reversed;

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
    for (var i = 0; i < inList.length; i++) {
      if (prevj >= 0 && inList[i] == outList[prevj].last)
        j = prevj;
      else
        j = _sum(outList[0]) < _sum(outList[1]) ? 0 : 1;
      outList[j].add(inList[i]);
      prevj = j;
    }
    if (outList[1].length < 1) outList[1].add(outList[0].removeLast());
    if (outList[0].length < 1) outList[0].add(outList[1].removeLast());

    // ===== return ======
    return outList;
  }

  // la suma de valores de una lista
  int _sum(List<int> data) =>
      data.fold(0, (previousValue, element) => previousValue + element).toInt();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Si un solo elemento -> FIN
      if (data.length == 1)
        return MiCaja(
            txt: '''
${data[0]}
${constraints.maxWidth.toInt()} x ${constraints.maxHeight.toInt()}
${(constraints.maxWidth * constraints.maxHeight).toInt()}''',
            tip: '${data[0]}');

      // Si más elementos -> Repartimos
      var listas = _repartirItems(data);

      if (constraints.maxWidth > constraints.maxHeight) {
        // Si es más Ancho que Alto ->ROW
        return Row(children: [
          Expanded(
            flex: _sum(listas[0]),
            child: LayoutRecursivo(data: listas[0]),
          ),
          Expanded(
            flex: _sum(listas[1]),
            child: LayoutRecursivo(data: listas[1]),
          )
        ]);
      }
      // Es más Alto que Ancho -> COLUMN
      return Column(children: [
        Expanded(
          flex: _sum(listas[0]),
          child: LayoutRecursivo(data: listas[0]),
        ),
        Expanded(
          flex: _sum(listas[1]),
          child: LayoutRecursivo(data: listas[1]),
        )
      ]);
    });
  }
}

class MiCaja extends StatelessWidget {
  const MiCaja({Key key, @required this.txt, this.tip}) : super(key: key);

  final String txt;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 2, 0, 0),
      decoration: BoxDecoration(
        color: Colors.grey[50], //blueGrey[50],
        border: Border.all(
          color: Colors.grey[400], //blueGrey[200],
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Center(
        child: Tooltip(
          message: tip,
          child: Text(txt, textAlign: TextAlign.center),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          showDuration: Duration(seconds: 10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.9),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          textStyle: TextStyle(
            color: Colors.white,
          ),
          preferBelow: true,
          verticalOffset: 20,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Stateless Widget',
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int yas;

  @override
  void initState() {
    // TODO: implement initState
    yas = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      yas += 8;
                    });
                  },
                  child: Text('Değiştir')),
              YuvarlakContainer(
                yas: yas,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class YuvarlakContainer extends StatelessWidget {
  int yas;

  YuvarlakContainer({@required this.yas});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Center(
        child: Text('$yas'),
      ),
      decoration: BoxDecoration(
          color: Colors.yellow[400], borderRadius: BorderRadius.circular(30)),
    );
  }
}

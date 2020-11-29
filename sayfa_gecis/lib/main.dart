import 'package:flutter/material.dart';
import 'package:sayfa_gecis/detailpage.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sayfa Gecis',
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: DetailPage(
                    yas: 4,
                  )));
        },
        child: Container(
          width: 120,
          height: 40,
          color: Colors.green,
          child: Center(
            child: Text('Giriş Yap'),
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  int yas;
  DetailPage({this.yas});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$yas'),
            Container(
              width: 120,
              height: 40,
              color: Colors.blue,
              child: Center(
                child: Text('Geri Dön'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CupertinoApp(
    title: 'Cupertino Example',
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              child: Text('iOS Style'),
              onPressed: () => print('tıklandı'),
              color: CupertinoColors.systemGrey,
            ),
            FlatButton(onPressed: () {}, child: Text('Material Design'))
          ],
        ),
      ),
    );
  }
}

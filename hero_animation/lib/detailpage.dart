import 'package:flutter/material.dart';
import 'package:hero_animation/photos.dart';

class DetailPage extends StatefulWidget {
  Photos myphoto;
  DetailPage({this.myphoto});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: widget.myphoto.id.toString(),
            child: Image.network(widget.myphoto.url),
          ),
          Text(widget.myphoto.title)
        ],
      ),
    );
  }
}

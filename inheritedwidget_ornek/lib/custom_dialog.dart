import 'package:flutter/material.dart';
import 'state_container.dart';
import 'user.dart';

class CustomDialog extends StatefulWidget {
  User user;
  String buttonText;
  GlobalKey<ScaffoldState> myscState;
  CustomDialog({this.user, this.buttonText = 'Ekle', this.myscState});
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  insertProcess(String text) async {
    final container = StateContainer.of(context);
    Navigator.pop(context);
    container.addUser(widget.user).then((value) {
      widget.myscState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    });
  }

  updateProcess(String text) async {
    final container = StateContainer.of(context);
    Navigator.pop(context);
    container.updateUser(widget.user).then((value) {
      widget.myscState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    offset: new Offset(0, 4),
                    blurRadius: 12)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sqlite İşlem',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 22,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: widget.user.name,
                decoration: InputDecoration(hintText: 'İsminizi giriniz'),
                onChanged: (value) {
                  widget.user.name = value;
                },
              ),
              TextFormField(
                initialValue: widget.user.surname,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: 'Soyisminizi giriniz'),
                onChanged: (value) {
                  widget.user.surname = value;
                },
              ),
              TextFormField(
                initialValue: widget.user.email,
                decoration: InputDecoration(hintText: 'Emailinizi giriniz'),
                onChanged: (value) {
                  widget.user.email = value;
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      if (widget.buttonText == 'Ekle') {
                        insertProcess('Kayıt Eklendi');
                      } else if (widget.buttonText == 'Güncelle') {
                        updateProcess('Kayıt Güncellendi');
                      }
                    },
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(fontSize: 18),
                    )),
              )
            ],
          ),
        ),
        Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Center(
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

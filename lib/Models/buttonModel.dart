import 'package:flutter/material.dart';

class Buttonolurins extends StatelessWidget {
  Buttonolurins(this.txt, this.color1, this.color2, this.func, this.color3, this.color4, this.Width, this.Height);
  final String txt;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;
  final double Width;
  final double Height;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color3, width: 2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15)),
          gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          boxShadow:[
            BoxShadow(
              color: color1.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      constraints: BoxConstraints(maxWidth: 330, maxHeight: Height),
      child: MaterialButton(
        onPressed: func,
        minWidth: Width,
        height: Height,
        child: Text(
          txt,
          style: TextStyle(
              color: color4, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

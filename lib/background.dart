import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final double width,height;
  final Color color;

  const Background({Key key, this.width, this.height,this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      width: width,
      top: 0,
      height: height,
      child: ClipRRect(
        child: Container(color: color,),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: width==MediaQuery.of(context).size.width?Radius.circular(40):Radius.circular(0)),
      ),
    );
  }
}

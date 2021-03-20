import 'package:flutter/material.dart';

enum upDownOrNone {
  none, up, down,
}

class ThumbsUpDown extends StatefulWidget {
  @override
  _ThumbsUpDownState createState() => _ThumbsUpDownState();
}

class _ThumbsUpDownState extends State<ThumbsUpDown> {
  int ups = 0;
  int downs = 0;
  upDownOrNone thumbState = upDownOrNone.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      child: Row(
        children: <Widget>[
          _getThumbButton(Icons.thumb_up, upDownOrNone.up, Colors.green),
          SizedBox(width: 10,),
          _getThumbButton(Icons.thumb_down, upDownOrNone.down, Colors.red),
        ],
      ),
    );
  }
  _getThumbButton(IconData iconData, upDownOrNone thumb, Color activeColor) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(iconData, color: thumb == thumbState ? activeColor : Colors.black,),
          Text(thumb == upDownOrNone.up ? ups.toString() : downs.toString(),)
        ],
      ),
      onTap: () {
        if(thumbState == thumb) {
          setState(() {
            thumbState == upDownOrNone.none;
          });
        } else {
          setState(() {
            thumbState == thumb;
          });
        }
      },
    );
  }
}

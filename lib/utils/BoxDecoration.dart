import 'package:flutter/material.dart';

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      new BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 4,
        offset: Offset(1.5, 1.5),
      ),
    ],
  );
}
BoxDecoration buildColorBoxDecoration(Color _color) {
  return BoxDecoration(
    color: _color,
    borderRadius: BorderRadius.circular(4),
    boxShadow: [
      new BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 4,
        offset: Offset(1.5, 1.5),
      ),
    ],
  );
}
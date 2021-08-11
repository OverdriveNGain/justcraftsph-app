//import 'package:flutter/material.dart';

String flatDouble(double d) {
  int flat = d ~/ 1;
  return (d == flat) ? flat.toString() : d.toString();
}

String timeStamp(){
  final dt = DateTime.now();
  return '${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2,'0')}${dt.year}_${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2, '0')}_${dt.millisecondsSinceEpoch}';
}

String unix(){
  return DateTime.now().millisecondsSinceEpoch.toString();
}


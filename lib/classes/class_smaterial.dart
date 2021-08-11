import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_crafts_ph/shared/shared_funcs.dart' as funcs;

enum SmaterialType {
  Standard,
  LaminatedStandard,
  Glossy,
  LaminatedGlossy,
  Semiclear,
  LaminatedSemiclear
}

class Smaterial {
  final SmaterialType type;
  final String name;
  final bool waterResistant;
  final bool waterProof;
  final bool scratchResistant;
  final bool writable;
  final bool textured;
  final double retailPrice;
  final double bulkPrice;

  String getFeatures() {
    String temp = '';
    if (waterProof)
      temp += (temp == '' ? '' : ', ') + 'Waterproof';
    else if (waterResistant)
      temp += (temp == '' ? '' : ', ') + 'Water Resistant';
    if (scratchResistant)
      temp += (temp == '' ? '' : ', ') + 'Scratch Resistant';
    if (writable) temp += (temp == '' ? '' : ', ') + 'Writable';
    if (textured) temp += (temp == '' ? '' : ', ') + 'Textured';
    return temp;
  }

  Smaterial({
    @required this.type,
    @required this.name,
    @required this.waterResistant,
    @required this.waterProof,
    @required this.scratchResistant,
    @required this.writable,
    @required this.textured,
    @required this.retailPrice,
    @required this.bulkPrice,
  });

  Widget toMaterialTile(bool clickable, Function _onPressed) {
    _onPressed = _onPressed ?? () {};
    final btn = ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary:
                clickable ? Colors.white : Color.fromARGB(150, 255, 255, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            elevation: clickable ? 2.0 : 0.0),
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Opacity(
                    child: Text(
                      getFeatures().replaceAll(', ', '\n'),
                      style: TextStyle(fontSize: 12.0),
                    ),
                    opacity: 0.5,
                  ),
                ],
              )),
              Column(
                children: [
                  Text('${funcs.flatDouble(retailPrice)}/A4'),
                  SizedBox(height: 5.0),
                  Opacity(
                    child: Text(
                      'Retail Price',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    opacity: 0.5,
                  ),
                ],
              ),
              SizedBox(width: 15.0),
              Column(
                children: [
                  Text('${funcs.flatDouble(bulkPrice)}/A4'),
                  SizedBox(height: 5.0),
                  Opacity(
                    child: Text(
                      'Bulk Price',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    opacity: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ));
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: clickable ? btn : AbsorbPointer(child: btn),
    );
  }

  static SmaterialType getSmaterialType(String s) {
    return SmaterialType.values
        .firstWhere((element) => s == element.toString().split('.').last);
  }
}

import 'package:flutter/material.dart';
import 'package:just_crafts_ph/txt/prices.dart' as prices;

class StickerTabCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            child: Text("Let us create your custom stickers!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18.0,)),
          ),
          Divider(),
          SizedBox(height: 10.0),
          Text(
            'May they be artworks, logos, or pictures. Let us turn your files into wonderful stickers!',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.0),
          Opacity(
              child: Text(
                'Start by selecting a material below:',
                textAlign: TextAlign.center,
              ),
              opacity: 0.5),
          SizedBox(height: 10.0),
          Column(
            children: prices.smaterials
                .map((e) => e.toMaterialTile(true, () async{
              await Navigator.pushNamed(context, 'customBuy', arguments:e);
            }))
                .toList(),
          ),
        ]));
  }
}

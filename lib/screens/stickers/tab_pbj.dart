import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_pbj.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/widgets/widget_pbj_thumbnail.dart';

class StickerTabPbj extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
            children: <Widget>[
              Container(
                padding:
                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                child: Text(
                    "Planners, books and journal stickers! Writable stickers for all your bookworm needs!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18.0,)),
              ),
              Divider()
            ] +
                generatePbjList(StickerInfo.st.pbjs)));
  }

  List<Widget> generatePbjList(List<StickerPbj> pbjs) {
    final spacingBox = SizedBox(height: 5.0, width:5.0);
    List<Widget> temp = [];
    for (int i = 0; i < pbjs.length; i += 2) {
      temp.add(Row(children: [
        spacingBox,
        Expanded(
          child: Container(
              child: PbjThumbnail(pbjs[i])),
        ),
        spacingBox,
        Expanded(
            child: Container(
                child:
                PbjThumbnail((i + 1 == pbjs.length) ? null : pbjs[i + 1]))),
        spacingBox,
      ]));
      temp.add(spacingBox);
    }
    return temp;
  }
}

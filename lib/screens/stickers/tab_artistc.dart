import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/widgets/widget_artist_thumbnail.dart';

class StickerTabArtistC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
            children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Text("Stickers made by different artists!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18.0,
                        )),
                  ),
                  Divider(),
                  // Container(child: generateArtistCView(StickerInfo.st.artistcs))
                  // ])),
                ] +
                generateArtistCList(StickerInfo.st.artistcs)));
  }

  List<Widget> generateArtistCList(List<StickerArtistC> artcs) {
    final spacingBox = SizedBox(width: 5.0, height: 5.0);
    List<Widget> temp = [];
    for (int i = 0; i < artcs.length; i += 2) {
      temp.add(Row(children: [
        spacingBox,
        Expanded(
          child: ArtistCThumbnail(artcs[i]),
        ),
        spacingBox,
        Expanded(
            child: ArtistCThumbnail(
                (i + 1 == artcs.length) ? null : artcs[i + 1])),
      ]));
      temp.add(spacingBox);
    }
    return temp;
  }
}

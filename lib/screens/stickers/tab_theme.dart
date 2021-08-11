import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_theme.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/widgets/widget_theme_thumbnail.dart';

class StickerTabTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
              child: Text(
                  "Theme stickers are great for laptops, bedroom walls, and phones!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18.0,)),
            ),
            Divider(),
          ] +
              generateThemesList(StickerInfo.st.themes)),
    );
  }

  List<Widget> generateThemesList(List<StickerTheme> themes) {
    final spacingBox = SizedBox(height:5.0, width:5.0);
    List<Widget> temp = [];
    for (int i = 0; i < themes.length; i += 2) {
      temp.add(Row(children: [
        spacingBox,
        Expanded(
          child: Container(
              child: ThemeThumbnail(themes[i])),
        ),
        spacingBox,
        Expanded(
            child: Container(
                child: ThemeThumbnail(
                    (i + 1 == themes.length) ? null : themes[i + 1]))),
        spacingBox,
      ]));
      temp.add(spacingBox);
    }
    return temp;
  }
}

// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:just_crafts_ph/screens/stickers/tab_artistc.dart';
import 'package:just_crafts_ph/screens/stickers/tab_custom.dart';
import 'package:just_crafts_ph/screens/stickers/tab_pbj.dart';
import 'package:just_crafts_ph/screens/stickers/tab_theme.dart';
import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';
import 'package:just_crafts_ph/classes/class_loading_info.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';

class ScreenStickers extends StatefulWidget {//todo: change to stateless widget?
  @override
  _ScreenStickersState createState() => _ScreenStickersState();
}

class _ScreenStickersState extends State<ScreenStickers> {
  final ButtonStyle customEmpty =
      OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey[600]));
  final ButtonStyle customDone = OutlinedButton.styleFrom(
      backgroundColor: Colors.yellow,
      side: BorderSide(color: Colors.green[600]));
  final Color customButtonTextColorDone = Colors.white;
  final Color customButtonTextColorEmpty = Colors.grey[600];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          drawer: JcphDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Theme"),
                Tab(text: "PB&J"),
                Tab(text: "Artist's\nCorner"),
                Tab(text: "Custom")
              ],
            ),
            title: Text("Browse Stickers"),
            actions: [
              FlatButton.icon(
                label: Text('Cart'),
                icon: Icon(Icons.shopping_cart_rounded),
                onPressed: () {
                  Navigator.pushNamed(context, 'loading', arguments: LoadingInfo(
                    isReplacement: false,
                    nextRouteNamed: 'scart',
                    loadingText: 'Loading order summary...',
                    func: () async {
                      await FileManager.st.loadOrders();
                      return;
                    }
                  ));
                },
              )
            ],
          ),
          body: TabBarView(children: [
            StickerTabTheme(),
            StickerTabPbj(),
            StickerTabArtistC(),
            StickerTabCustom(),
          ])),
    );
  }
}
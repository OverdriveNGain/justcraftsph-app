import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_crafts_ph/screens/screen_debug.dart';
import 'package:just_crafts_ph/screens/screen_fullscreen_image.dart';
import 'package:just_crafts_ph/screens/screen_loading.dart';
import 'package:just_crafts_ph/screens/screen_new_address.dart';
import 'package:just_crafts_ph/screens/screen_pof_info.dart';
import 'package:just_crafts_ph/screens/screen_shopping_cart.dart';
import 'package:just_crafts_ph/screens/screen_faq.dart';
import 'package:just_crafts_ph/screens/screen_pick_address.dart';
import 'package:just_crafts_ph/screens/screen_payment.dart';
import 'package:just_crafts_ph/screens/stickers/screen_artistc_buy.dart';
import 'package:just_crafts_ph/screens/stickers/screen_custom_buy.dart';
import 'package:just_crafts_ph/screens/stickers/screen_pbj_buy.dart';
import 'package:just_crafts_ph/screens/stickers/screen_stickers.dart';
import 'package:just_crafts_ph/screens/stickers/screen_theme_buy.dart';
import 'package:just_crafts_ph/shared/shared_theme.dart' as customthemes;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        routes: {
          'faq': (context) => ScreenFaq(),
          'stickers': (context) => ScreenStickers(),
          'themeBuy' : (context) => ScreenThemeBuy(),
          'pbjBuy' : (context) => ScreenPbjBuy(),
          'artistCBuy' : (context) => ScreenArtistCBuy(),
          'imgpreview': (context) => ScreenImagePreview(),
          'scart' : (context) => ScreenShoppingCart(),
          'debug' : (context) => ScreenDebug(),
          'pickaddress' : (context) => ScreenPickAddress(),
          'newaddress' : (context) => ScreenNewAddress(),
          'pofinfo' : (context) => ScreenPofInfo(),
          'loading' : (context) => ScreenLoading(),
          'customBuy' : (context) => ScreenCustomBuy(),
          'payment' : (context) => ScreenPricing(),
        },
        title: 'Flutter Demo',
        theme: customthemes.standardTheme,
        home: ScreenLoading()
    );
  }
}

// todo: Chalianne: customer wants to see price before inputting details
// todo: Chalianne: admin page

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
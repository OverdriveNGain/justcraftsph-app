import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_code_quantity.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/classes/class_theme.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';
import 'package:just_crafts_ph/widgets/widget_add_to_cart.dart';
import 'package:just_crafts_ph/classes/class_order_params.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart'
    as firebase_storage;
import 'package:just_crafts_ph/classes/class_fullscreen_image_info.dart';
import 'package:flutter/services.dart';
// import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';
// import 'dart:math';

class ScreenThemeBuy extends StatefulWidget {
  @override
  _ScreenThemeBuyState createState() => _ScreenThemeBuyState();
}

class _ScreenThemeBuyState extends State<ScreenThemeBuy> {
  List<int> designCounts;
  ThemeOrder themeOrder;
  StickerTheme sTheme;

  ImageProvider imageProviderPreview;

  @override
  Widget build(BuildContext context) {
    
    if (sTheme == null) {
      final args = ModalRoute.of(context).settings.arguments;

      if (args is StickerTheme) {
        themeOrder = null;

        sTheme = args;

        designCounts = List.generate(sTheme.codes.length, (index) => 0);
      } else if (args is ThemeOrder) {
        themeOrder = args;

        StickerInfo st = StickerInfo.st;
        sTheme = st.getTheme(themeOrder.codePrefix);

        designCounts = themeOrder.codes.map((e) => e.quantity).toList();
      }
    }

    int stickerCount = designCounts.reduce((value, element) => value + element);

    return Scaffold(
        appBar: AppBar(
          title: Text(sTheme.title),
        ),
        body: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTapDown: (t) async {
                        if (imageProviderPreview == null) return;

                        await Navigator.pushNamed(context, 'imgpreview',
                            arguments: FullScreenImageInfo(
                                heroTag: sTheme.title,
                                imageProvider: imageProviderPreview));
                        await SystemChrome.setPreferredOrientations([
                          // DeviceOrientation.landscapeRight,
                          // DeviceOrientation.landscapeLeft,
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // double size =
                          //     min(constraints.maxHeight, constraints.maxWidth);
                          return Center(
                              child: DynamicCachedNetworkImage(
                            gsUrl: '${firebase_storage.gsRoot}/theme_batch/${sTheme.imgBatch}',
                            builder: (context, provider) {
                              imageProviderPreview = provider;
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(100, 0, 0, 0),
                                        offset: Offset(2.0, 3.0),
                                        blurRadius: 5.0,
                                      )
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Hero(
                                      child: Image(image: provider),
                                      tag: sTheme.title),
                                ),
                              );
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    "Tap to enlarge",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height:10.0),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              for (int i = 0; i < designCounts.length; i++)
                                if (--designCounts[i] < 0)
                                  designCounts[i] = 0;
                              setState(() {});
                            },
                            child: Text(
                              "Remove Set",
                              textAlign: TextAlign.center,
                            )),
                      )),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              for (int i = 0;
                                  i < designCounts.length;
                                  i++) designCounts[i]++;
                              setState(() {});
                            },
                            child: Text(
                              "Add Set",
                              textAlign: TextAlign.center,
                            )),
                      )),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              for (int i = 0;
                                  i < designCounts.length;
                                  i++) designCounts[i] = 0;
                              setState(() {});
                            },
                            child: Text("Reset")),
                      )),
                    ],
                  ),
                ),
                Container(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 15.0),
                      SizedBox(width: 15.0)
                    ]..insertAll(
                        1,
                        sTheme.codes.map((s) =>
                            counter(s, sTheme.codes.indexOf(s))))
                  ),
                )),
                Divider(),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  height: 50.0,
                  child: buildAddToCart(stickerCount, context),
                ),
              ],
            )));
  }

  AddToCart buildAddToCart(int stickerCount, BuildContext context) {
    if (themeOrder == null)
      return AddToCart(
          enabled: (stickerCount > 0),
          func: () {
            FileManager.st.addOrder(ThemeOrder()
              ..initFromParams(
                ThemeOrderParams(
                    codePrefix: sTheme.codePrefix,
                    imgPreview: sTheme.imgBatch,
                    codes: List.generate(
                        designCounts.length,
                        (index) => CodeQuantity(
                            sTheme.codePrefix + (index + 1).toString(),
                            designCounts[index]))),
              ));
            Fluttertoast.showToast(
                msg: "Item added to cart!",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 1,
                textColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).colorScheme.surface,
                fontSize: 16.0);
            Navigator.pop(context);
          });
    return AddToCart(
        btnIcon: Icons.save,
        message: 'Save Changes',
        enabled: (stickerCount > 0),
        func: () async {
          for (int i = 0; i < designCounts.length; i++) {
            themeOrder.codes[i].quantity = designCounts[i];
          }
          FileManager fm = FileManager.st;
          await fm.updateOrder(themeOrder);
          Fluttertoast.showToast(
              msg: "Changes saved!",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 1,
              textColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.surface,
              fontSize: 16.0);
          Navigator.pop(context);
        });
  }
  //
  Widget counter(String code, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 60.0,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white
            ),
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                designCounts[index]++;
              });
            },
          ),
          SizedBox(height: 10.0),
          Text("${designCounts[index]}",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.0),
          Text(code),
          SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white
            ),
            child: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (--designCounts[index] < 0) designCounts[index] = 0;
              });
            },
          ),
        ],
      ),
    );
  }
}

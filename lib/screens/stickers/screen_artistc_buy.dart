import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'package:just_crafts_ph/classes/class_code_quantity.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';
import 'package:just_crafts_ph/widgets/widget_add_to_cart.dart';
import 'package:just_crafts_ph/widgets/widget_commission_dialog.dart';
import 'package:just_crafts_ph/classes/class_order_params.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart'
    as firebase_storage;
import 'package:just_crafts_ph/classes/class_fullscreen_image_info.dart';
import 'package:flutter/services.dart';
//import 'dart:math';
//import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';

class ScreenArtistCBuy extends StatefulWidget {
  @override
  _ScreenArtistCBuyState createState() => _ScreenArtistCBuyState();
}

class _ScreenArtistCBuyState extends State<ScreenArtistCBuy> {
  List<int> designCounts;
  ArtistCOrder artistCOrder;
  StickerArtistC sArtistC;

  // String batchImageUrl;
  ImageProvider batchImageProviderPreview;

  // String dpImageUrl;
  ImageProvider dpImageProviderPreview;

  @override
  Widget build(BuildContext context) {
    // final StickerArtistC aTheme = ModalRoute.of(context).settings.arguments;
    // if (designCounts == null)
    //   designCounts = List.generate(aTheme.codes.length, (index) => 0);

    if (sArtistC == null) {
      final args = ModalRoute.of(context).settings.arguments;

      if (args is StickerArtistC) {
        artistCOrder = null;

        sArtistC = args;

        designCounts = List.generate(sArtistC.codes.length, (index) => 0);
      } else if (args is ArtistCOrder) {
        artistCOrder = args;

        StickerInfo st = StickerInfo.st;
        sArtistC = st.getArtistC(artistCOrder.codePrefix);

        designCounts = artistCOrder.codes.map((e) => e.quantity).toList();
      }
    }

    int stickerCount = designCounts.reduce((value, element) => value + element);

    // if (batchImageUrl == null || dpImageUrl == null) getImageUrl();

    return Scaffold(
        appBar: AppBar(
          title: Text(sArtistC.themeName),
        ),
        body: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 70.0,
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxHeight,
                          child: DynamicCachedNetworkImage(
                            gsUrl: '${firebase_storage.gsRoot}/artistc_dp/${sArtistC.artist.imgDp}',
                            builder: (context, provider) {
                              dpImageProviderPreview = provider;
                              return ClipOval(child: Image(image: provider));
                            },
                          ),
                        );
                      }),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Artist'),
                            // SizedBox(height: 7.0),
                            Text(sArtistC.artist.name,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      RaisedButton(
                          child: Text(
                            'Commision me!',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ArtistCommissionDialog(
                                artistC: sArtistC,
                              ),
                            );
                          })
                    ],
                  ),
                ),
                Divider(),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTapDown: (t) async {
                        await Navigator.pushNamed(context, 'imgpreview',
                            arguments: FullScreenImageInfo(
                                heroTag: sArtistC.themeName,
                                imageProvider: batchImageProviderPreview));
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
                                  builder: (context, provider) {
                                    batchImageProviderPreview = provider;
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(100, 0, 0, 0),
                                              offset: Offset(2.0, 3.0),
                                              blurRadius: 5.0,
                                            )
                                          ]),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Hero(
                                            child: Image(image: provider),
                                            tag: sArtistC.themeName),
                                      ),
                                    );
                                  },
                                  gsUrl: '${firebase_storage.gsRoot}/artistc_batch/${sArtistC.imgBatch}'));
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height:5.0),
                Opacity(child: Text("Tap to enlarge", textAlign: TextAlign.center), opacity: 0.4),
                SizedBox(height:5.0),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: RaisedButton(
                            onPressed: () {
                              for (int i = 0;
                                  i < designCounts.length;
                                  i++)
                                if (--designCounts[i] < 0)
                                  designCounts[i] = 0;
                              setState(() {});
                            },
                            color: Colors.white,
                            child: Text(
                              "Remove Set",
                              textAlign: TextAlign.center,
                            )),
                      )),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: RaisedButton(
                            onPressed: () {
                              for (int i = 0;
                                  i < designCounts.length;
                                  i++) designCounts[i]++;
                              setState(() {});
                            },
                            color: Colors.white,
                            child: Text(
                              "Add Set",
                              textAlign: TextAlign.center,
                            )),
                      )),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: RaisedButton(
                            onPressed: () {
                              for (int i = 0;
                                  i < designCounts.length;
                                  i++) designCounts[i] = 0;
                              setState(() {});
                            },
                            color: Colors.white,
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
                              sArtistC.codes.map((s) =>
                                  counter(s, sArtistC.codes.indexOf(s))))
                      ),
                    )
                ),
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
    if (artistCOrder == null)
      return AddToCart(
          enabled: (stickerCount > 0),
          func: () {
            FileManager.st.addOrder(ArtistCOrder()
              ..initFromParams(ArtistCOrderParams(
                  codePrefix: sArtistC.codePrefix,
                  imgPreview: sArtistC.imgBatch,
                  codes: List.generate(
                      designCounts.length,
                      (index) => CodeQuantity(
                          sArtistC.codePrefix + index.toString(),
                          designCounts[index])))));
            Fluttertoast.showToast(
                msg: "Item added to cart!",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 1,
                textColor: Theme.of(context).colorScheme.onSurface,
                fontSize: 16.0);
            Navigator.pop(context);
          });
    return AddToCart(
        btnIcon: Icons.save,
        message: 'Save Changes',
        enabled: (stickerCount > 0),
        func: () async {
          for (int i = 0; i < designCounts.length; i++) {
            artistCOrder.codes[i].quantity = designCounts[i];
          }
          FileManager fm = FileManager.st;
          await fm.updateOrder(artistCOrder);
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

  Widget counter(String code, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 60.0,
      child: Column(
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            child: Icon(Icons.add),
            color: Colors.white,
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
          Text(code), //, style: TextStyle(fontStyle: FontStyle.italic)),
          SizedBox(height: 10.0),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0)),
            child: Icon(Icons.remove),
            color: Colors.white,
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

  // Center buildLoading() => Center(child: CircularProgressIndicator());
  // Future<void> getImageUrl() async {
  //   final urls = await Future.wait([
  //     firebase_storage
  //         .getDownloadUrlCached('artistc_batch/${sArtistC.imgBatch}'),
  //     // firebase_storage.getDownloadUrlCached('artistc_dp/${sArtistC.artist.imgDp}'),
  //   ]);
  //   batchImageUrl = urls[0];
  //   // dpImageUrl = urls[1];
  //
  //   setState(() {});
  // }
}

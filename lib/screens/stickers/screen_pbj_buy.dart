import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_code_quantity.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/classes/class_pbj.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';
import 'package:just_crafts_ph/widgets/widget_add_to_cart.dart';
import 'package:just_crafts_ph/classes/class_order_params.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart' as firebase_storage;
import 'package:just_crafts_ph/classes/class_fullscreen_image_info.dart';
import 'package:flutter/services.dart';
//import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';

class ScreenPbjBuy extends StatefulWidget {
  @override
  _ScreenPbjBuyState createState() => _ScreenPbjBuyState();
}

class _ScreenPbjBuyState extends State<ScreenPbjBuy> {
  int designCount = 0;
  PbjOrder pbjOrder;
  StickerPbj sPbj;

  ImageProvider imageProviderPreview;

  @override
  Widget build(BuildContext context) {
    if (sPbj == null) {
      final args = ModalRoute.of(context).settings.arguments;

      if (args is StickerPbj) {
        pbjOrder = null;

        sPbj = args;
      } else if (args is PbjOrder) {
        pbjOrder = args;

        StickerInfo st = StickerInfo.st;
        sPbj = st.getPbj(pbjOrder.codePrefix);

        designCount = pbjOrder.codeQuantity.quantity;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(sPbj.title),
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
                        if (imageProviderPreview == null)
                          return;
                        await Navigator.pushNamed(context, 'imgpreview',
                            arguments: FullScreenImageInfo(
                                heroTag: sPbj.title,
                                imageProvider: imageProviderPreview
                            ));
                        await SystemChrome.setPreferredOrientations([
                          // DeviceOrientation.landscapeRight,
                          // DeviceOrientation.landscapeLeft,
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                              child: DynamicCachedNetworkImage(
                                  builder: (context, provider) {
                                    imageProviderPreview = provider;
                                    return Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(100, 0, 0, 0),
                                          offset: Offset(2.0, 3.0),
                                          blurRadius: 5.0,
                                        )]),
                                      child: Hero(
                                          child: Image(image:provider),
                                          tag: sPbj.title
                                      ),
                                    );
                                  },
                                  gsUrl:'${firebase_storage.gsRoot}/pbj_batch/${sPbj.imgBatch}',
                              )
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height:5.0),
                Opacity(
                  opacity:0.4,
                  child: Text(
                    "Tap to enlarge",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height:5.0),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.white),
                          onPressed: () {
                            designCount = 0;
                            setState(() {});
                          },
                          child: Text("Reset")),
                    ),
                    Container(child: counter(sPbj.code)),
                  ],
                ),
                Divider(),
                Container(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    height: 50.0,
                    child: buildAddToCart(designCount, sPbj,context),
                  ),
                ),
              ],
            )));
  }

  AddToCart buildAddToCart(int count, StickerPbj sPbj, BuildContext context) {
    if (pbjOrder == null)
      return AddToCart(
      enabled: (designCount > 0),
      func: () {
        FileManager.st.addOrder(PbjOrder()
          ..initFromParams(PbjOrderParams(
            imgPreview: sPbj.imgBatch,
            codePrefix: sPbj.code,
            code: CodeQuantity(sPbj.code, designCount),
          )));
        Fluttertoast.showToast(
            msg: "Item added to cart!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            textColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            fontSize: 16.0);
        Navigator.pop(context);
      },
    );
    return AddToCart(
      btnIcon: Icons.save,
      message: 'Save Changes',
      enabled: (designCount > 0),
      func: () async{
        pbjOrder.codeQuantity.quantity = count;
        FileManager fm = FileManager.st;
        await fm.updateOrder(pbjOrder);
        Fluttertoast.showToast(
            msg: "Changes saved!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            textColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            fontSize: 16.0);
        Navigator.pop(context);
      },
    );
  }

  Widget counter(String code) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 60.0,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                designCount++;
              });
            },
          ),
          SizedBox(height: 10.0),
          Text("$designCount",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.0),
          Text(code), //, style: TextStyle(fontStyle: FontStyle.italic)),
          SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
            child: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (--designCount < 0) designCount = 0;
              });
            },
          ),
        ],
      ),
    );
  }
}

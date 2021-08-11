import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';
// import 'package:just_crafts_ph/classes/class_theme.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart';
import 'package:just_crafts_ph/txt/prices.dart' as prices;
import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';
// import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';
import 'package:image_picker/image_picker.dart' as imgPicker;
import 'dart:io';
import 'package:just_crafts_ph/shared/shared_funcs.dart' as funcs;
// import 'package:just_crafts_ph/txt/discounts.dart' as discounts;
import 'package:just_crafts_ph/classes/class_receipt.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart'
    as firebase_storage;

class ScreenShoppingCart extends StatefulWidget {
  @override
  _ScreenShoppingCartState createState() => _ScreenShoppingCartState();
}

class _ScreenShoppingCartState extends State<ScreenShoppingCart> {
  //todo: going back to browse will clear the picked address
  final _sizedBox = SizedBox(height: 10.0);
  final _sizedBoxHalf = SizedBox(height: 5.0);
  final _listTilePadding = EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0);
  final _imgPicker = imgPicker.ImagePicker();
  final _opacity = 0.4;

  bool enabled = true;

  File imgPof;
  Address shippingAddress;
  bool sameDayDelivery = false;
  double stickerGrandTotal = 0;
  double shippingTotal = 0;

  @override
  Widget build(BuildContext context) {
    stickerGrandTotal = 0;
    return Scaffold(
      // drawer: JcphDrawer(),
      appBar: AppBar(
        title: Text("Shopping Cart"),
        actions: [
          TextButton.icon(
            label: Text('Browse'),
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'stickers');
            },
          )
        ],
      ),
      body: Container(
        child: receipt(context) ??
            Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Oh no, you\'re shopping cart is empty!\n\n'),
                    TextSpan(text: '(-_-;)\n\n'),
                    TextSpan(text: 'Press'),
                    TextSpan(
                        text: ' Browse ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'in the upper right to explore stickers!\n\n')
                  ],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground)),
            )),
      ),
      // color: Theme.of(context).colorScheme.background,
    );
  }

  Widget receipt(BuildContext context) {
    if (FileManager.st.orders.length == 0) return null;

    return ListView(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Color.fromARGB(50, 0, 0, 0),
                      offset: Offset(0, 2.0),
                    ),
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: receiptHeader(context) +
                      receiptThemeList(context) +
                      receiptPbjList(context) +
                      receiptArtistCList(context) +
                      receiptCustomList(context) +
                      receiptFooter(context)),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> receiptHeader(BuildContext context) {
    return <Widget>[
      Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 2.0,
            endIndent: 10.0,
          )),
          Text(
            "O R D E R   S U M M A R Y",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          Expanded(child: Divider(thickness: 2.0, indent: 10.0)),
        ],
      ),
      SizedBox(height: 20.0)
    ];
  }

  List<Widget> receiptThemeList(BuildContext context) {
    String _stickerTotalStr(int count) {
      if (count <= 5)
        return '$count sticker${count == 1 ? '' : 's'} → ₱${funcs.flatDouble(prices.themePrice5)}';
      if (count <= 10)
        return '$count sticker${count == 1 ? '' : 's'} → ₱${funcs.flatDouble(prices.themePrice10)}';
      if (count <= 15)
        return '$count sticker${count == 1 ? '' : 's'} → ₱${funcs.flatDouble(prices.themePrice15)}';
      if (count <= 20)
        return '$count sticker${count == 1 ? '' : 's'} → ₱${funcs.flatDouble(prices.themePrice20)}';
      return '$count stickers x ₱${funcs.flatDouble(prices.themePriceAbove)} = ₱${funcs.flatDouble(prices.themePriceAbove * 5)}';
    }

    double _stickerTotal(int count) {
      // called only once per setState
      if (count <= 5) {
        stickerGrandTotal += prices.themePrice5;
        return prices.themePrice5;
      }
      if (count <= 10) {
        stickerGrandTotal += prices.themePrice10;
        return prices.themePrice10;
      }
      if (count <= 15) {
        stickerGrandTotal += prices.themePrice15;
        return prices.themePrice15;
      }
      if (count <= 20) {
        stickerGrandTotal += prices.themePrice20;
        return prices.themePrice20;
      }
      stickerGrandTotal += (count * prices.themePriceAbove);
      return count * prices.themePriceAbove;
    }

    List<ThemeOrder> partialList = [];
    FileManager.st.orders
        .where((element) => element is ThemeOrder)
        .forEach((element) {
      partialList.add(element);
    });
    partialList.sort((a, b) => int.parse(a.unix) - int.parse(b.unix));

    if (partialList.length == 0) return [];

    List<int> indivCount = List<int>.generate(partialList.length,
        (index) => partialList[index].getIndividualStickerCount());

    int sum = 0;
    if (indivCount.length == 1)
      sum = indivCount[0];
    else if (indivCount.length > 1)
      sum = indivCount.reduce((value, element) => value + element);

    return <Widget>[Text("     Theme Stickers"), _sizedBox] +
        List<Widget>.generate(
            partialList.length,
            (i) => Padding(
                  padding: _listTilePadding,
                  child: ListTile(
                    leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: DynamicCachedNetworkImage(
                        gsUrl: '${firebase_storage.gsRoot}/theme_batch/' +
                            StickerInfo.st
                                .getBatchTheme(partialList[i].codePrefix),
                      ),
                    ),
                    trailing: Transform.translate(
                      offset: Offset(18.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(partialList[i].getCountText()),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert,
                                color: Theme.of(context).colorScheme.onSurface),
                            itemBuilder: (context) => [
                              PopupMenuItem(child: Text("Edit"), value: 'edit'),
                              PopupMenuItem(
                                  child: Text("Delete"), value: 'delete')
                            ],
                            onSelected: (s) async {
                              switch (s) {
                                case 'edit':
                                  await Navigator.pushNamed(context, 'themeBuy',
                                      arguments: partialList[i]);
                                  setState(() {});
                                  break;
                                case 'delete':
                                  List<Order> o = FileManager.st.orders;
                                  o.remove(partialList[i]);
                                  FileManager.st.saveOrders();
                                  setState(() {});
                                  break;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    title: Text(partialList[i].getOrderName(),
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(partialList[i].getDetails(),
                        overflow: TextOverflow.ellipsis),
                  ),
                )).toList() +
        [
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Opacity(
                opacity: _opacity,
                child: Text(
                  _stickerTotalStr(sum),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 20.0)
            ],
          ),
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Theme stickers total: ₱${funcs.flatDouble(_stickerTotal(sum))}",
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 20.0),
            ],
          ),
          _sizedBox,
          Divider()
        ];
  }

  List<Widget> receiptCustomList(BuildContext context) {
    List<CustomOrder> partialList = [];
    FileManager.st.orders
        .where((element) => element is CustomOrder)
        .forEach((element) {
      partialList.add(element);
    });
    partialList.sort((a, b) => int.parse(a.unix) - int.parse(b.unix));

    if (partialList.length == 0) return [];

    double customTotal = 0;
    String _customTotal(CustomOrder order) {
      final pageCount = order.pageCount;
      double price = 0;
      if (pageCount >= prices.customBulkCountMinimum)
        price = prices.smaterials
            .firstWhere((element) => element.type == order.smaterial.type)
            .bulkPrice;
      else
        price = prices.smaterials
            .firstWhere((element) => element.type == order.smaterial.type)
            .retailPrice;

      String fac1 =
          "$pageCount sheet${pageCount == 1 ? '' : 's'} x ₱${funcs.flatDouble(price)}";
      double total = price * pageCount;
      customTotal += total;
      stickerGrandTotal += total;
      return fac1 + ' = ₱${funcs.flatDouble(total)}';
    }

    return <Widget>[Text("     Custom Stickers"), _sizedBox] +
        partialList
            .map((order) {
              return [
                Container(
                  padding: _listTilePadding,
                  // padding: EdgeInsets.all(50.0),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    // leading: Image.asset(order.imgPreview),
                    trailing: Transform.translate(
                      offset: Offset(18.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(order.getCountText()),
                          Container(
                            child: PopupMenuButton(
                              icon: Icon(Icons.more_vert,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: Text("Edit"), value: 'edit'),
                                PopupMenuItem(
                                    child: Text("Delete"), value: 'delete')
                              ],
                              onSelected: (s) async {
                                switch (s) {
                                  case 'edit':
                                    await Navigator.pushNamed(
                                        context, 'customBuy',
                                        arguments: order);
                                    setState(() {});
                                    break;
                                  case 'delete':
                                    List<Order> o = FileManager.st.orders;
                                    o.remove(order);
                                    FileManager.st.saveOrders();
                                    setState(() {});
                                    break;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    title: Text(order.getOrderName(),
                        overflow: TextOverflow.ellipsis),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order
                          .getDetails()
                          .split('\n')
                          .map((e) => Text(e, overflow: TextOverflow.ellipsis))
                          .toList(),
                    ),
                  ),
                ),
                _sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Opacity(
                      opacity: _opacity,
                      child: Text(
                        _customTotal(order),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 20.0)
                  ],
                ),
                _sizedBox,
              ];
            })
            .toList()
            .reduce((a, b) => a + b) +
        [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Artist's Corner total: ₱${funcs.flatDouble(customTotal)}",
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 20.0)
            ],
          ),
          Divider()
        ];
  }

  List<Widget> receiptPbjList(BuildContext context) {
    String _pbjTotalStr(int sum) {
      double fourSet = (sum ~/ prices.pbjPackCount).toDouble();
      double single = (sum % prices.pbjPackCount).toDouble();
      String fac1 = fourSet == 0
          ? ''
          : '${funcs.flatDouble(fourSet)} bundle${fourSet == 1 ? '' : 's'} of ${prices.pbjPackCount} x ₱${funcs.flatDouble(prices.pbjPackPrice)}';
      String fac2 = single == 0
          ? ''
          : '${funcs.flatDouble(single)} set${single == 1 ? '' : 's'} x ₱${funcs.flatDouble(prices.pbjSinglePrice)}';
      bool both = fac1 != "" && fac2 != "";
      if (both) {
        fac1 = "($fac1)";
        fac2 = "($fac2)";
      }

      return fac1 +
          '${both ? ' + ' : ''}' +
          fac2 +
          ' = ₱${funcs.flatDouble((prices.pbjSinglePrice * single) + (prices.pbjPackPrice * fourSet))}';
    }

    double _pbjTotal(int sum) {
      // called only once per setState

      int fourSet = sum ~/ prices.pbjPackCount;
      int single = sum % prices.pbjPackCount;
      double tempTotal =
          (prices.pbjSinglePrice * single) + (prices.pbjPackPrice * fourSet);
      stickerGrandTotal += tempTotal;
      return tempTotal;
    }

    List<PbjOrder> partialList = [];
    FileManager.st.orders
        .where((element) => element is PbjOrder)
        .forEach((element) {
      partialList.add(element);
    });
    partialList.sort((a, b) => int.parse(a.unix) - int.parse(b.unix));

    if (partialList.length == 0) return [];

    int sum = 0;
    for (int i = 0; i < partialList.length; i++) {
      sum += partialList[i].codeQuantity.quantity;
    }

    return <Widget>[Text("     PB&J Stickers"), _sizedBox] +
        List<Widget>.generate(
            partialList.length,
            (i) => Padding(
                  padding: _listTilePadding,
                  child: ListTile(
                    // leading: Image.asset(si.getBatchPbj(partialList[i].codePrefix)),
                    leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: DynamicCachedNetworkImage(
                        gsUrl: '${firebase_storage.gsRoot}/pbj_batch/' +
                            StickerInfo.st
                                .getBatchPbj(partialList[i].codePrefix),
                      ),
                    ),
                    trailing: Transform.translate(
                      offset: Offset(18.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(partialList[i].getCountText()),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert,
                                color: Theme.of(context).colorScheme.onSurface),
                            itemBuilder: (context) => [
                              PopupMenuItem(child: Text("Edit"), value: 'edit'),
                              PopupMenuItem(
                                  child: Text("Delete"), value: 'delete')
                            ],
                            onSelected: (s) async {
                              print('button hit');
                              switch (s) {
                                case 'edit':
                                  await Navigator.pushNamed(context, 'pbjBuy',
                                      arguments: partialList[i]);
                                  setState(() {});
                                  break;
                                case 'delete':
                                  print('deleting');
                                  List<Order> o = FileManager.st.orders;
                                  o.remove(partialList[i]);
                                  FileManager.st.saveOrders();
                                  setState(() {});
                                  break;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    title: Text(partialList[i].getOrderName(),
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(partialList[i].getDetails(),
                        overflow: TextOverflow.ellipsis),
                  ),
                )).toList() +
        [
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Opacity(
                opacity: _opacity,
                child: Text(
                  _pbjTotalStr(sum),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 20.0)
            ],
          ),
          _sizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "PB&J stickers total: ₱${funcs.flatDouble(_pbjTotal(sum))}",
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 20.0)
            ],
          ),
          _sizedBox,
          Divider()
        ];
  }

  List<Widget> receiptArtistCList(BuildContext context) {
    List<ArtistCOrder> partialList = [];
    FileManager.st.orders
        .where((element) => element is ArtistCOrder)
        .forEach((element) {
      partialList.add(element);
    });
    partialList.sort((a, b) => int.parse(a.unix) - int.parse(b.unix));

    if (partialList.length == 0) return [];

    double artistCTotal = 0;
    String _artistTotal(ArtistCOrder order) {
      List<double> prices =
          StickerInfo.st.artistSetSinglePrices(order.codePrefix);
      List<int> counts = order.setSinglePair();
      String fac1 = counts[0] == 0
          ? ""
          : "${counts[0]} set${counts[0] == 1 ? '' : 's'} x ₱${funcs.flatDouble(prices[0])}";
      String fac2 = counts[1] == 0
          ? ""
          : "${counts[1]} single${counts[1] == 1 ? '' : 's'} x ₱${funcs.flatDouble(prices[1])}";
      bool both = fac1 != "" && fac2 != "";
      if (both) {
        fac1 = "($fac1)";
        fac2 = "($fac2)";
      }
      double total = (prices[0] * counts[0]) + (prices[1] * counts[1]);
      artistCTotal += total;
      stickerGrandTotal += total;
      return fac1 +
          '${both ? ' + ' : ''}' +
          fac2 +
          ' = ₱${funcs.flatDouble(total)}';
    }

    return <Widget>[Text("     Artist's Corner Stickers"), _sizedBox] +
        partialList
            .map((order) {
              return [
                Padding(
                  padding: _listTilePadding,
                  child: ListTile(
                    // leading: Image.asset(StickerInfo.st.getBatchArtistC(order.codePrefix)),
                    leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: DynamicCachedNetworkImage(
                        gsUrl: '${firebase_storage.gsRoot}/artistc_batch/' +
                            StickerInfo.st.getBatchArtistC(order.codePrefix),
                      ),
                    ),
                    trailing: Transform.translate(
                      offset: Offset(18.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(order.getCountText()),
                          Container(
                            child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: Text("Edit"), value: 'edit'),
                                PopupMenuItem(
                                    child: Text("Delete"), value: 'delete')
                              ],
                              onSelected: (s) async {
                                switch (s) {
                                  case 'edit':
                                    await Navigator.pushNamed(
                                        context, 'artistCBuy',
                                        arguments: order);
                                    setState(() {});
                                    break;
                                  case 'delete':
                                    List<Order> o = FileManager.st.orders;
                                    o.remove(order);
                                    FileManager.st.saveOrders();
                                    setState(() {});
                                    break;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    tileColor: Colors.grey[100],
                    title: Text(order.getOrderName(),
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(order.getDetails(),
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                _sizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Opacity(
                      opacity: _opacity,
                      child: Text(
                        _artistTotal(order),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 20.0)
                  ],
                ),
                _sizedBox,
              ];
            })
            .toList()
            .reduce((a, b) => a + b) +
        [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Artist's Corner total: ₱${funcs.flatDouble(artistCTotal)}",
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 20.0)
            ],
          ),
          Divider()
        ];
  }

  List<Widget> receiptFooter(BuildContext context) {
    if (shippingAddress == null)
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: OutlinedButton(
            child: Text(
              '\n\nEnter Shipping Information to Proceed...\n\n',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              dynamic s = await Navigator.pushNamed(context, 'pickaddress');
              shippingAddress = s;
              setState(() {});
            },
          ),
        )
      ];
    else {
      shippingTotal = prices.getShippingFee(shippingAddress.region);

      return <Widget>[Text("     Shipping Details")] +
          [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              child: toAddressTile(shippingAddress),
            )
          ] +
          [Divider()] +
          [
            !sameDayDelivery
                ? Row(children: [
                    Expanded(
                        child: Text(
                            "     Shipping Fee (${Address.displayStringFromRegion(shippingAddress.region)})")),
                    Text(
                        '₱${funcs.flatDouble(prices.getShippingFee(shippingAddress.region))}'),
                    SizedBox(width: 20.0),
                  ])
                : Text('     Shipping Fee will be paid on the delivery date',
                    style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: buildDeliveryOptionSwitch(),
            ),
            Divider(),
          ] +
          [
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                child: Column(children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextFormField(
                  //         validator: (s) {
                  //           // todo: implement discount function
                  //           return 'toImplement';
                  //         },
                  //         controller: _discountController,
                  //         decoration: InputDecoration(
                  //           hintText: 'Coming soon!',
                  //           filled:true ,
                  //           hoverColor: Colors.white,
                  //           focusColor: Colors.white,
                  //           fillColor: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width:15.0),
                  //     RaisedButton(
                  //       onPressed: () {
                  //
                  //       },
                  //       child: Text(
                  //         'Enter',
                  //         // style: TextStyle(color: Colors.white),
                  //       ),
                  //       // color: Colors.brown,
                  //     )
                  //   ],
                  // ),
                  // _sizedBox,
                  Center(
                      child: Text(
                          "Total: ₱${funcs.flatDouble(stickerGrandTotal + (sameDayDelivery ? 0 : shippingTotal))}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0))),
                  _sizedBox,
                  placeOrderButton(context),
                  _sizedBox,
                  Opacity(
                    child: Text(
                        '*You will be presented with payment options after placing your order.'),
                    opacity: _opacity,
                  ),
                ])),
          ];
    }
  }

  ElevatedButton buildDeliveryOptionSwitch() {
    if (shippingAddress.region == Region.MetroManila) {
      if (sameDayDelivery)
        return ElevatedButton(
            onPressed: () {
              setState(() {
                sameDayDelivery = false;
              });
            },
            child: Text('Switch to standard delivery'));
      return ElevatedButton(
          onPressed: () {
            setState(() {
              sameDayDelivery = true;
            });
          },
          child: Text('Switch to same-day delivery'));
    }
    return ElevatedButton(
        onPressed: null,
        child: Text('Same-day delivery only available for Metro Manila'));
  }

  Future getPof() async {
    imgPof = File(
        (await _imgPicker.getImage(source: imgPicker.ImageSource.gallery))
            .path);
  }

  Widget placeOrderButton(BuildContext context) {
    return ElevatedButton(
        child: Text('Place Order', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                    child: OrderingDialogInfo(
                  context: context,
                  shippingTotal: shippingTotal,
                  sameDayDelivery: sameDayDelivery,
                  shippingAddress: shippingAddress,
                  stickerGrandTotal: stickerGrandTotal,
                  orders: FileManager.st.orders,
                ));
              });
        });
  }

  Future<String> zipToUpload(List<File> files) async {
    // String allLines
    // await IoHelper.write('toUpload.txt', lines.reduce((value, element) => value + '\n' + element));
    // final textPath = await IoHelper.getFullPath('toUpload.txt');

    return await IoHelper.zipFromFiles(files, 'toUpload.zip');
  }

  List<T> insertAtAll<T>(List<T> list, T toInsert, bool insertAtEnd) {
    return List<T>.generate(list.length * 2 - (insertAtEnd ? 0 : 1),
        (index) => index % 2 == 1 ? toInsert : list[index ~/ 2]);
  }

  Container toAddressTile(Address e) {
    // todo:fix the variable below; copy pasted from screen_pick_address.dart
    TextStyle _infoDataStyle = TextStyle(fontSize: 14.0);

    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: insertAtAll(
                  [
                        Opacity(opacity: _opacity, child: Text('Name')),
                        Text(e.name, style: _infoDataStyle),
                        _sizedBoxHalf,
                        Opacity(opacity: _opacity, child: Text('Address')),
                        Text(e.address, style: _infoDataStyle),
                        _sizedBoxHalf,
                        Opacity(opacity: _opacity, child: Text('Number')),
                        Text(e.number, style: _infoDataStyle),
                        _sizedBoxHalf,
                        Opacity(
                          opacity: _opacity,
                          child: Text('Region'),
                        ),
                        Text(Address.displayStringFromRegion(e.region),
                            style: _infoDataStyle),
                        _sizedBoxHalf,
                      ] +
                      (e.deliveryInstructions.trim() == ''
                          ? []
                          : [
                              Opacity(
                                opacity: _opacity,
                                child: Text('Delivery Instructions'),
                              ),
                              Text(e.deliveryInstructions,
                                  style: _infoDataStyle),
                              _sizedBoxHalf,
                            ]) +
                      (e.email.trim() == ''
                          ? []
                          : [
                              Opacity(
                                opacity: _opacity,
                                child: Text('Email to Send Receipt:'),
                              ),
                              Text(e.email, style: _infoDataStyle),
                            ]),
                  SizedBox(height: 5.0),
                  false),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('Change'), value: 'change'),
            ],
            onSelected: (s) async {
              switch (s) {
                case 'change':
                  dynamic s = await Navigator.pushNamed(context, 'pickaddress',
                      arguments: shippingAddress);
                  if (s != null) {
                    shippingAddress = s;
                    setState(() {});
                  }
                  break;
              }
            },
          )
        ],
      ),
    );
  }

  Future<File> getProofOfPayment() async {
    File f = imgPof;
    String path = 'popCopied.${f.path.split('/').last.split('.')[1]}';
    return await IoHelper.copy(imgPof, path);
  }
}

class OrderingDialogInfo extends StatefulWidget {
  final Address shippingAddress;
  final bool sameDayDelivery;
  final double stickerGrandTotal;
  final double shippingTotal;
  final BuildContext context;
  final List<Order> orders;

  const OrderingDialogInfo({
    @required this.shippingAddress,
    @required this.sameDayDelivery,
    @required this.stickerGrandTotal,
    @required this.shippingTotal,
    @required this.orders,
    @required this.context,
    Key key,
  }) : super(key: key);

  @override
  _OrderingDialogInfoState createState() => _OrderingDialogInfoState();
}

class _OrderingDialogInfoState extends State<OrderingDialogInfo> {
  Receipt finalreceipt;
  OrderingProcessStatus status =
      OrderingProcessStatus.Processing; // todo: reset to processing

  @override
  void initState(){
    super.initState();
    orderProcess();
  }

  @override
  Widget build(BuildContext context) {
    if (status == OrderingProcessStatus.Processing)
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(height: 20.0),
            Text('Please wait...', textWidthBasis: TextWidthBasis.parent),
          ],
        ),
        padding: EdgeInsets.all(20.0),
      );

    if (status == OrderingProcessStatus.Failed)
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.0),
            Text(
              'Can\'t upload order. Check internet connection, or recheck custom sticker files and try again.',
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary:Theme.of(context).colorScheme.secondary),
                      child: Text('Back', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                      onPressed: () {Navigator.pop(context);},
                    )),
                SizedBox(width: 10.0),
                Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
                      child: Text('Try again', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                      onPressed: () {},
                    )),
              ],
            )
          ],
        ),
        padding: EdgeInsets.all(10.0),
      );

    return Center();
  }

  Future<void> orderProcess() async {
    File f;
    try {
      finalreceipt = Receipt();
      finalreceipt.shippingPrice =
          prices.getShippingFee(widget.shippingAddress.region);
      finalreceipt.stickerPrice = widget.stickerGrandTotal;
      finalreceipt.address = widget.shippingAddress;
      finalreceipt.orders = widget.orders;
      finalreceipt.unix = DateTime.now().millisecondsSinceEpoch;
      finalreceipt.sameDayDelivery = widget.sameDayDelivery;
      finalreceipt.discount = null;

      f = await finalreceipt.zip();
    } catch (e) {
      print('Can\'t zip upload file.');
      print(e);

      setState(() {
        status = OrderingProcessStatus.Failed;
      });
      return;
    }
    // upload to firebase  // todo: create a mechanism that saves locally if not connected to internet
    if (f != null && await f.exists()) {
      print('Uploading request...');
      if (await firebase_storage.uploadFile(f,
          'orders/${datetimeToJcphFormat(DateTime.now())}_${widget.shippingAddress.name}.zip')){
        print('Request upload done!');
        Fluttertoast.showToast(
            msg: "Order successfully submitted!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            textColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            fontSize: 16.0
        );
        List<Order> o = FileManager.st.orders;
        o.clear();
        FileManager.st.saveOrders();
        Navigator.pushReplacementNamed(context, 'payment', arguments: (widget.stickerGrandTotal + (widget.sameDayDelivery?0:widget.shippingTotal)));
        return true;
      }
      print('Upload failed');
      setState(() {
        status = OrderingProcessStatus.Failed;
      });
      return false;
    } else {
      print('Upload failed');
      setState(() {
        status = OrderingProcessStatus.Failed;
      });
      return false;
    }
  }

  String datetimeToJcphFormat(DateTime dt) {
    final m = dt.month;
    final d = dt.day;
    return "${m < 10 ? '0' : ''}$m-${d < 10 ? '0' : ''}$d-${dt.year}-${dt.hour}:${dt.minute}:${dt.second}.${dt.millisecond}";
  }
}

enum OrderingProcessStatus { Processing, Failed }

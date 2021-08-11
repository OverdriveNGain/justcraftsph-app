import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_tuple.dart';
import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';
import 'package:meta/meta.dart';
import 'package:just_crafts_ph/shared/shared_funcs.dart' as funcs;

class ScreenPricing extends StatelessWidget {
  // final _headerInfoSpacing = SizedBox(height: 10.0);
  // final _paymentHeaderLeftSpace = '  ';
  // final _paymentInfoLeftSpace = '        ';
  final _paymentHeaderStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w400);
  // final _paymentInfoStyle = TextStyle();

  final _paymentOptions = [
    PaymentOption(
        imagePath: 'images/payment_options/paymaya.png',
        title: 'Paymaya',
        details: [
          Tuple2('Account Number', '09959632500'),
          Tuple2('Account Name', 'Jeremy Mattheu D. Amon'),
        ],
        backgroundColor: Color.fromARGB(255, 1, 52, 78)),
    PaymentOption(
        imagePath: 'images/payment_options/gcash.png',
        title: 'GCash',
        details: [
          Tuple2('Account Number', '09959632500'),
          Tuple2('Account Name', 'Jeremy Mattheu D. Amon'),
        ],
        backgroundColor: Colors.white),
    PaymentOption(
        imagePath: 'images/payment_options/banktransfer.png',
        title: 'Bank Transfer',
        details: [
          Tuple2('Bank Name', '(BDO) Banco de Oro'),
          Tuple2('Account Number', '003660127331'),
          Tuple2('Account Name', 'Jeremy Mattheu D. Amon')
        ],
        backgroundColor: Colors.white),
  ];
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    double finalPrice;
    if (args != null && args is double) {
      finalPrice = args;
    }
    bool fromCart = finalPrice != null;

    return Scaffold(
      drawer: !fromCart ? JcphDrawer() : null,
      appBar: AppBar(
        title: Text("Payment"),
        automaticallyImplyLeading: !fromCart,
      ),
      body: Container(
        // color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              fromCart
                  ? buildPaymentHeader(context, finalPrice)
                  : buildPricingHeader(context),
              SizedBox(height: 10.0),
              Divider(),
              Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[] +
                      (_paymentOptions
                          .map((option) => SizedBox(
                                height: 65.0,
                                child: AspectRatio(
                                  aspectRatio: 3,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 10.0),
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Material(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: option.backgroundColor,
                                            elevation: 5.0,
                                            child: SizedBox.expand(),
                                          ),
                                          ClipRRect(
                                              child:
                                                  Image.asset(option.imagePath),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          Material(
                                            type: MaterialType.transparency,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            elevation: 5.0,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Dialog(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                      Widget>[
                                                                    Text(
                                                                      option
                                                                          .title,
                                                                      style:
                                                                          _paymentHeaderStyle,
                                                                    ),
                                                                    Divider(),
                                                                  ] +
                                                                  buildOptionsList(
                                                                      option),
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                            ),
                                                          ),
                                                        ));
                                              },
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ))
                          .toList())),
              Divider(),
              fromCart ? buildPaymentFooter(context) : Center()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPricingHeader(BuildContext context) => Text(
        'Once you have placed your order, you can pay via the following methods.\n\n Tap on each tile for payment details:',
        textAlign: TextAlign.center,
      );

  Widget buildPaymentHeader(BuildContext context, double finalPrice) =>
      Column(children: [
        Text('Your grand total is ₱${funcs.flatDouble(finalPrice)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        SizedBox(height: 20.0),
        Text(
          'Tap on each tile for payment details:',
          textAlign: TextAlign.center,
        ),
      ]);

  Widget buildPaymentFooter(BuildContext context) => Column(children: [
        Opacity(
            opacity: 0.4,
            child: Text(
              'Note that orders with no associated payment within 24 hours of paying will be cancelled',
              textAlign: TextAlign.center,
            )),
        SizedBox(height: 20.0),
    ElevatedButton(
      style: ElevatedButton.styleFrom(primary:Theme.of(context).colorScheme.secondary),
          child: Text('I have made my payment. I\'m good!',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
          onPressed: () {
            Fluttertoast.showToast(
                msg: "Thank you for trusting in Just Crafts PH!",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 1,
                textColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).colorScheme.surface,
                fontSize: 16.0
            );
            Navigator.pushReplacementNamed(context, 'stickers');
          },
        )
      ]);

  List<Widget> buildOptionsList(PaymentOption option) {
    List<Widget> temp = [];
    for (int i = 0; i < option.details.length; i++) {
      temp.add(Text(option.details[i].item1,
          style: TextStyle(fontWeight: FontWeight.bold)));
      temp.add(Text(option.details[i].item2));
      if (i != option.details.length - 1) temp.add(SizedBox(height: 10.0));
    }
    return temp;
  }
}

class PaymentOption {
  String imagePath;
  String title;
  List<Tuple2> details;
  Color backgroundColor;

  PaymentOption({
    @required this.imagePath,
    @required this.title,
    @required this.details,
    @required this.backgroundColor,
  });
}

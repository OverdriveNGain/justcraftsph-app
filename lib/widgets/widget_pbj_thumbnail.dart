import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_pbj.dart';
import 'dart:math';
import 'package:just_crafts_ph/firebase/firebase_storage.dart'
    as firebase_storage;
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';

class PbjThumbnail extends StatefulWidget {
  static const _borderRadius = BorderRadius.all(Radius.circular(20.0));
  static const _boxShadow = BoxShadow(
      blurRadius: 2.0,
      offset: Offset(0, 2.0),
      color: Color.fromARGB(100, 0, 0, 0));
  static const _linearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.fromARGB(0, 0, 0, 0), Color.fromARGB(200, 0, 0, 0)],
    stops: [0, 0.8],
  );
  static const _height = 150.0;
  static const _fontSize = 20.0;

  const PbjThumbnail(
    this.pTheme, {
    Key key,
  }) : super(key: key);

  final StickerPbj pTheme;

  @override
  _PbjThumbnailState createState() => _PbjThumbnailState();
}

class _PbjThumbnailState extends State<PbjThumbnail> {
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pTheme == null) {
      return Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
        height: PbjThumbnail._height,
      );
    }
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: PbjThumbnail._borderRadius,
              boxShadow: [PbjThumbnail._boxShadow],
              color: Colors.grey[100]),
          height: PbjThumbnail._height,
          // padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
          child: ClipRRect(
              borderRadius: PbjThumbnail._borderRadius,
              child: LayoutBuilder(builder: (context, constraints) {
                return OverflowBox(
                    maxWidth: constraints.maxWidth,
                    maxHeight: double.infinity,
                    child: DynamicCachedNetworkImage(
                      gsUrl: '${firebase_storage.gsRoot}/pbj_batch/${widget.pTheme.imgBatch}',
                    )); //todo: implement error display
              })),
        ),
        Material(
          color: Color.fromARGB(0, 0, 0, 0),
          borderRadius: PbjThumbnail._borderRadius,
          child: Ink(
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'pbjBuy',
                      arguments: widget.pTheme);
                },
                borderRadius: PbjThumbnail._borderRadius,
                splashColor: Colors.white.withAlpha(200),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                      borderRadius: PbjThumbnail._borderRadius,
                      gradient: PbjThumbnail._linearGradient),
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.pTheme.title,
                      style: TextStyle(
                          fontSize: PbjThumbnail._fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 5.0,
                                offset: Offset.fromDirection(pi * 0.4, 5.0))
                          ])),
                )),
            height: PbjThumbnail._height,
          ),
        ),
      ],
    );
  }
}

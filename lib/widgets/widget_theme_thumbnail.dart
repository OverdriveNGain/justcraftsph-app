import 'package:flutter/material.dart';
import 'dart:math';
import 'package:just_crafts_ph/classes/class_theme.dart';
import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';

class ThemeThumbnail extends StatefulWidget {
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
  const ThemeThumbnail(
    this.sTheme, {
    Key key,
  }) : super(key: key);

  final StickerTheme sTheme;

  @override
  _ThemeThumbnailState createState() => _ThemeThumbnailState();
}

class _ThemeThumbnailState extends State<ThemeThumbnail> {

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sTheme == null) {
      return Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
        height: ThemeThumbnail._height,
      );
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: ThemeThumbnail._borderRadius, boxShadow: [ThemeThumbnail._boxShadow],
          color: Colors.grey[100]),
          height: ThemeThumbnail._height,
          child: ClipRRect(
              borderRadius: ThemeThumbnail._borderRadius,
              child: LayoutBuilder(builder: (context, constraints) {
                return OverflowBox(
                    maxWidth: constraints.maxWidth,
                    maxHeight: double.infinity,
                    child: DynamicCachedNetworkImage(
                      gsUrl: 'gs://just-crafts-ph.appspot.com/theme_batch/${widget.sTheme.imgBatch}',
                      priority: CachePriority.Cache,
                    )
                  );
              })),
        ),
        Material(
          color: Color.fromARGB(0, 0, 0, 0),
          borderRadius: ThemeThumbnail._borderRadius,
          child: Ink(
            child: InkWell(
                onTap: () {
                  print('hit1');
                  Navigator.pushNamed(context, 'themeBuy', arguments: widget.sTheme);

                },
                borderRadius: ThemeThumbnail._borderRadius,
                splashColor: Colors.white.withAlpha(200),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  height: 200.0,
                  decoration: BoxDecoration(
                      borderRadius: ThemeThumbnail._borderRadius, gradient: ThemeThumbnail._linearGradient),
                  alignment: Alignment.bottomLeft,
                  child: Text(widget.sTheme.title,
                      style: TextStyle(
                          fontSize: ThemeThumbnail._fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 5.0,
                                offset: Offset.fromDirection(pi * 0.4, 5.0))
                          ])),
                )),
            height: ThemeThumbnail._height,
          ),
        ),
      ],
    );
  }
}

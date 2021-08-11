import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'dart:math';
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';

class ArtistCThumbnail extends StatefulWidget {
  static const _borderRadius = BorderRadius.all(Radius.circular(20.0));
  static const _boxShadow = BoxShadow(
      blurRadius: 2.0,
      offset: Offset(0, 2.0),
      color: Color.fromARGB(100, 0, 0, 0));
  static const _linearGradient = LinearGradient(
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
    colors: [Color.fromARGB(0,0,0,0), Color.fromARGB(200,0,0,0)],
    stops: [0, 0.8],
  );
  static const _height = 150.0;
  static const _fontSizeTitle = 20.0;
  static const _fontSizeArtist = 15.0;
  const ArtistCThumbnail(
      this.aTheme, {
        Key key,
      }) : super(key: key);

  final StickerArtistC aTheme;

  @override
  _ArtistCThumbnailState createState() => _ArtistCThumbnailState();
}

class _ArtistCThumbnailState extends State<ArtistCThumbnail> {
  // String imageUrl;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.aTheme == null){
      return Container(
        padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
        height: ArtistCThumbnail._height,
      );
    }

    // if (imageUrl == null) getImageUrl();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: ArtistCThumbnail._borderRadius,
              boxShadow: [
                ArtistCThumbnail._boxShadow
              ],
              color: Colors.grey[100]
          ),
          height:ArtistCThumbnail._height,
          child: ClipRRect(
              borderRadius: ArtistCThumbnail._borderRadius,
              child: LayoutBuilder(
                  builder: (context, constraints){
                    return OverflowBox(
                        maxWidth: constraints.maxWidth,
                        maxHeight: double.infinity,
                        child:DynamicCachedNetworkImage(
                          gsUrl: 'gs://just-crafts-ph.appspot.com/artistc_batch/${widget.aTheme.imgBatch}',
                        )
                        );
                  }
              )
          ),
        ),
        Material(
          color: Color.fromARGB(0, 0, 0, 0),
          borderRadius: ArtistCThumbnail._borderRadius,
          child: Ink(
            child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, 'artistCBuy', arguments:widget.aTheme);

                },
                borderRadius: ArtistCThumbnail._borderRadius,
                splashColor: Colors.white.withAlpha(200),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  height:200.0,
                  decoration: BoxDecoration(
                      borderRadius: ArtistCThumbnail._borderRadius,
                      gradient: ArtistCThumbnail._linearGradient
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.aTheme.themeName, style: TextStyle(
                          fontSize: ArtistCThumbnail._fontSizeTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5.0, offset: Offset.fromDirection(pi * 0.4, 5.0))]
                      )),
                      Text("by ${widget.aTheme.artist.name}", style: TextStyle(
                          fontSize: ArtistCThumbnail._fontSizeArtist,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5.0, offset: Offset.fromDirection(pi * 0.4, 5.0))]
                      ))
                    ],
                  ),
                )
            ),
            height:ArtistCThumbnail._height,
          ),
        ),
      ],
    );
  }
}
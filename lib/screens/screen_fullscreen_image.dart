import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_fullscreen_image_info.dart';
import 'package:flutter/services.dart';

class ScreenImagePreview extends StatefulWidget {
  @override
  _ScreenImagePreviewState createState() => _ScreenImagePreviewState();
}

class _ScreenImagePreviewState extends State<ScreenImagePreview> {

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    FullScreenImageInfo imageInfo = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
        body: InteractiveViewer(
          child: GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              },
            child: Container(
              alignment: Alignment.center,
              color: Colors.black,
                child:Hero(
                    child: Image(image:imageInfo.imageProvider),
                    tag: imageInfo.heroTag
                )
            ),
          ),
        )
    );
  }
}

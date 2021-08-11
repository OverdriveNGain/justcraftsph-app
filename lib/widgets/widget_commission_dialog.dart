import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'package:just_crafts_ph/shared/shared_links.dart' as url;
import 'package:just_crafts_ph/shared/shared_email.dart' as mail;
import 'package:just_crafts_ph/widgets/widget_dynamic_cached_network_image.dart';
import 'package:meta/meta.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart' as firebase_storage;

class ArtistCommissionDialog extends StatefulWidget {
  final StickerArtistC artistC;
  // final _headerHeight = 40.0;

  ArtistCommissionDialog({
    @required this.artistC,
  });

  @override
  _ArtistCommissionDialogState createState() => _ArtistCommissionDialogState();
}

class _ArtistCommissionDialogState extends State<ArtistCommissionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99999),
                border: Border.all(color: Theme.of(context).accentColor,width: 5.0)
              ),
              width: 150.0,
              height: 150.0,
              child: ClipOval(
                child: DynamicCachedNetworkImage(
                    builder: (context, provider) {
                      return Image(image: provider);
                    },
                    gsUrl: '${firebase_storage.gsRoot}/artistc_dp/${widget.artistC.artist.imgDp}'
                )
              ),
            ),
            SizedBox(height: 10.0,),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.artistC.artist.name,
                style: TextStyle(
                    fontSize: 30.0
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Text(widget.artistC.artist.desc, textAlign: TextAlign.center,),
            Divider(height: 30.0),
            Text(
              'Contacts & Socials',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0
              ),
            )
          ] + getSocialList(widget.artistC)
        ),
      ),
    );
  }

  List<Widget> getSocialList(StickerArtistC artistTheme){
    return <Widget> [
      artistTheme.artist.fb==''?null:socialElement(
        Icons.crop_square,
          artistTheme.artist.fb,
        () async {
          await url.url('https://www.facebook.com/${artistTheme.artist.fb}'); // todo: toast if ever hindi kaya mag open
        }
      ),
      artistTheme.artist.tw==''?null:socialElement(
          Icons.crop_square,
          'Twitter: ${artistTheme.artist.tw}',
        () async {
            await url.url('https://www.twitter.com/${artistTheme.artist.tw.substring(1)}/');
        }
      ),
      artistTheme.artist.ig==''?null:socialElement(
          Icons.crop_square,
          'Instagram: ${artistTheme.artist.ig}',
        () async {
          await url.url('https://www.instagram.com/${artistTheme.artist.ig.substring(1)}/');
        }
      ),
      artistTheme.artist.email==''?null:socialElement(
          Icons.email,
          artistTheme.artist.email,
        () async {
            await mail.send('', '', [artistTheme.artist.email], []);
        }
      ),
    ].where((e) => e != null).toList();
  }

  Widget socialElement(IconData icon, String text, Future<void> Function() func){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Material(
        color: Colors.white,
          child: InkWell(
            onTap: func,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  children: [
                    Icon(icon),
                    SizedBox(width:15.0),
                    Text(text)
                  ]
              ),
            ),
          )
      ),
    );
  }
}

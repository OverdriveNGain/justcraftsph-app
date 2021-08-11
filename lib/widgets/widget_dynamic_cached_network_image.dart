import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart'
  as firebase_storage;
import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';

class DynamicCachedNetworkImage extends StatefulWidget {

  final String gsUrl;
  final String url;
  final CachePriority priority;
  final bool showLoading;
  final Widget Function(BuildContext, ImageProvider) builder;

  DynamicCachedNetworkImage({
    this.gsUrl,
    this.url,
    this.priority = CachePriority.Cache,
    this.showLoading = true,
    this.builder
  });

  @override
  _DynamicCachedNetworkImageState createState() => _DynamicCachedNetworkImageState();
}

class _DynamicCachedNetworkImageState extends State<DynamicCachedNetworkImage> {
  String url;

  @override
  Widget build(BuildContext context) {
    assert((widget.gsUrl != null) != (widget.url != null));

    if (url == null){
      if (widget.gsUrl != null)
        getImageUrl();
      else{
        url = widget.url;
      }
    }

    return url==null?buildLoading(context):CachedNetworkImage(
      imageUrl:url,
      placeholder: (context, str) => buildLoading(context),
      imageBuilder: widget.builder
    );
  }

  Center buildLoading(BuildContext context) => Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).colorScheme.primary,));

  Future<void> getImageUrl() async {
    url = await firebase_storage.getDownloadUrlCached(widget.gsUrl);
    setState((){});
  }
}

import 'package:url_launcher/url_launcher.dart' as urlLauncher;

Future<bool> url(String url) async{
  if (await urlLauncher.canLaunch(url)) {
    await urlLauncher.launch(
      url,
      universalLinksOnly: false,
    );
    return true;
  } else {
    throw 'There was a problem to open the url: $url';
  }
}
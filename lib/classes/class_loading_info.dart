import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:meta/meta.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/firebase/firebase.dart' as firebase;
import 'package:flutter/services.dart';

class LoadingInfo{
  final String loadingText;
  final String nextRouteNamed;
  final bool isReplacement;
  final Future<void> Function() func;

  LoadingInfo({
    @required this.loadingText,
    @required this.nextRouteNamed,
    @required this.isReplacement,
    @required this.func});

  static LoadingInfo launchInfo = LoadingInfo(
    loadingText: 'Loading stickers...',
    isReplacement: true,
    nextRouteNamed: 'stickers',
    func: () async {
      await SystemChrome.setPreferredOrientations([
        // DeviceOrientation.landscapeRight,
        // DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await FileManager.st.initFolders();
      await firebase.init();
      await StickerInfo.st.init();

      CachedPrefs.st = CachedPrefs();
      await CachedPrefs.st.init();
    }
  );
}
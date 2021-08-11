import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:just_crafts_ph/shared/shared_cached_prefs.dart';
//import 'package:firebase_core/firebase_core.dart';

firebase_storage.FirebaseStorage storage;

final gsRoot = 'gs://just-crafts-ph.appspot.com';

Future<void> init() async {
  storage = firebase_storage.FirebaseStorage.instance;
  return;
}

Future<bool> uploadFile(File file, String uploadedFilePath) async {
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref(uploadedFilePath)
        .putFile(file);
    return true;
  } on firebase_core.FirebaseException catch (e) {
    print('Failed to upload file.');
    print(e);
    return false;
  }
}

Future<String> getDownloadUrlCached(String path, {CachePriority cachePriority = CachePriority.Cache}) async {
  return await CachedPrefs.st.getSetString(path,
          () async => await storage.refFromURL(path).getDownloadURL(),
      Duration(hours: 1),
      cachePriority);
}


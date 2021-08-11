import 'package:firebase_core/firebase_core.dart';
import 'package:just_crafts_ph/firebase/firebase_storage.dart' as storage;
import 'package:just_crafts_ph/firebase/firebase_firestore.dart' as firestore;

bool _hasInitialized = false;

Future<void> init() async{
  if (_hasInitialized)
    return;
  await Firebase.initializeApp();
  await firestore.init();
  await storage.init();
  _hasInitialized = true;
  print('Initialized firebase.');
}
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'package:just_crafts_ph/classes/class_tuple.dart';
//import 'package:just_crafts_ph/classes/class_pbj.dart';
//import 'package:just_crafts_ph/classes/class_theme.dart';

firebase_firestore.FirebaseFirestore firestore;

Future<void> init() async {
  firestore = firebase_firestore.FirebaseFirestore.instance;
  return;
}

Future<List<Map<String, dynamic>>> getThemes() async{
  // Todo: Rework if number of themes are greater than 100
  return (await firestore.collection('themes').orderBy('title').get()).docs.map((e) => e.data()).toList();
}
Future<List<Map<String, dynamic>>> getPbjs() async{
  // Todo: Rework if number of themes are greater than 100
  return (await firestore.collection('pbjs').orderBy('title').get()).docs.map((e) => e.data()).toList();
}
Future<List<Tuple2<String,Map<String, dynamic>>>> getArtists() async{
  // Todo: Rework if number of themes are greater than 100
  return (await firestore.collection('artists').orderBy('name').get()).docs.map((e) => Tuple2(e.id, e.data())).toList();
}
Future<List<Map<String, dynamic>>> getArtistCs() async{
  // Todo: Rework if number of themes are greater than 100
  return (await firestore.collection('artistcs').orderBy('title').get()).docs.map((e) => e.data()).toList();
}

void updateDatabase(List<StickerArtistC> artistcs) async{
  // print('themes length is ${themes.length}');
  final docs = (await firestore.collection('artistcs').get()).docs;
  for (firebase_firestore.QueryDocumentSnapshot st in docs){
    String s = st.data()['image'];
    await st.reference.update({'image':s.replaceFirst('.png', '.jpg')});
    // var artist = docs.firstWhere((element) => element.data()['name'] == st.artist.name).reference;
    // await firestore.collection('artistcs').add({
    //   'image':st.imgBatch,
    //   'title':st.themeName,
    //   'iprice':st.singlePrice,
    //   'sprice':st.setPrice,
    //   'codes':st.codes.join(','),
    //   'artist':artist
    // });
  }
}
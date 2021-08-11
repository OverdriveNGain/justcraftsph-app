import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:just_crafts_ph/classes/class_artist.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/classes/class_theme.dart';
import 'package:just_crafts_ph/classes/class_acorner.dart';
import 'package:just_crafts_ph/classes/class_pbj.dart';
import 'package:just_crafts_ph/classes/class_tuple.dart';
import 'package:just_crafts_ph/firebase/firebase_firestore.dart' as firebase_firestore;

class StickerInfo {
  static StickerInfo _st;

  static StickerInfo get st {
    if (_st == null) _st = StickerInfo();
    return _st;
  }

  List<StickerTheme> themes = <StickerTheme>[];
  List<StickerPbj> pbjs = <StickerPbj>[];
  List<StickerArtistC> artistcs = <StickerArtistC>[];
  List<Artist> artists = <Artist>[];

  Future<void> init() async {
    await _initThemes();
    await _initPBJs();
    await _initArtistCs();
  }
  int getSetLength(String code) {
    if (code[0] == 'P' && getPrefix(code) == 'P') return 1;
    return themes
        .firstWhere((element) => element.codePrefix == code)
        .codes
        .length;
  }
  String getSetName(String code, OrderType type) {
    switch (type) {
      case OrderType.Theme:
        return themes.firstWhere((element) => element.codePrefix == code).title;
      case OrderType.Pbj:
        return pbjs.firstWhere((element) => element.code == code).title;
      case OrderType.ArtistC:
        code = getPrefix(code);
        return artistcs
            .firstWhere((element) => getPrefix(element.codePrefix) == code)
            .themeName;
      default:
        throw ('getSetName($code,$type) not implemented');
        break;
    }
  }

  String getBatchTheme(String prefix) => themes.firstWhere((element) => element.codePrefix == prefix).imgBatch;
  String getBatchPbj(String code) => pbjs.firstWhere((element) => element.code == code).imgBatch;
  String getBatchArtistC(String prefix) => artistcs.firstWhere((element) => element.codePrefix == prefix).imgBatch;

  StickerTheme getTheme(String prefix) => themes.firstWhere((element) => element.codePrefix == prefix);
  StickerPbj getPbj(String code) => pbjs.firstWhere((element) => element.code == code);
  StickerArtistC getArtistC(String prefix) => artistcs.firstWhere((element) => element.codePrefix == prefix);

  List<double> artistSetSinglePrices(String prefix) {
    try {
      StickerArtistC atheme =
          artistcs.firstWhere((element) => element.codePrefix == prefix);
      return [atheme.setPrice, atheme.singlePrice];
    } catch (e) {
      throw Exception("artistSetSinglePrices($prefix) error.");
    }
  }
  String getPrefix(String code) => code.replaceAll(new RegExp(r"([0-9])"), '');

  Future<void> _initThemes() async {
    // String themesTxt = await loadAsset('lib/txt/themes.txt');
    // List<String> lines = themesTxt.split("\n");
    // List<StickerTheme> temp = <StickerTheme>[];
    // int i = 0;
    // while (i < lines.length) {
    //   if (lines[i].trim().length != 0) {
    //     List<String> codes = lines[i + 2].trim().split(',');
    //     temp.add(StickerTheme(
    //         lines[i].trim(), lines[i + 1].trim(), codes, getPrefix(codes[0])));
    //     i += 2;
    //   }
    //   i++;
    // }
    // themes = temp;

    List<StickerTheme> temp = <StickerTheme>[];
    final themesQuery = await firebase_firestore.getThemes();
    print('themesQuery has length ${themesQuery.length}');
    for (Map<String,dynamic> theme in themesQuery){
      List<String> codes = theme['singles'].trim().split(',');
      temp.add(
        StickerTheme(theme['image'], theme['title'], codes, getPrefix(codes[0]))
      );
    }
    themes = temp;
  }
  Future<void> _initPBJs() async {
    // String themesTxt = await loadAsset('lib/txt/pbjs.txt');
    // List<String> lines = themesTxt.split("\n");
    // List<StickerPbj> temp = <StickerPbj>[];
    // int i = 0;
    // while (i < lines.length) {
    //   if (lines[i].trim().length != 0) {
    //     temp.add(StickerPbj(
    //         lines[i].trim(), lines[i + 1].trim(), lines[i + 2].trim()));
    //     i += 2;
    //   }
    //   i++;
    // }
    // pbjs = temp;

    List<StickerPbj> temp = <StickerPbj>[];
    final pbjsQuery = await firebase_firestore.getPbjs();
    print('pbjsQuery has length ${pbjsQuery.length}');
    for (Map<String,dynamic> theme in pbjsQuery){
      temp.add(
          StickerPbj(theme['image'], theme['code'], theme['title'])
      );
    }
    pbjs = temp;
  }
  Future<void> _initArtistCs() async {
    // String themesTxt = await loadAsset('lib/txt/artistcs.txt');
    // List<String> lines = themesTxt.split("\n");
    // List<StickerArtistC> temp = <StickerArtistC>[];
    // int i = 0;
    //
    // String img;
    // String title;
    // String name;
    // String codes;
    // String pricei;
    // String prices;
    // String desc;
    // String email;
    // String tw;
    // String ig;
    // String fb;
    // String imgDp;
    // while (i < lines.length) {
    //   if (lines[i].trim().length != 0) {
    //     List<String> parts = lines[i].split(':');
    //     String left = parts[0];
    //     String right = parts[1].trim();
    //     switch(left){
    //       case 'img':
    //         img = right;
    //         break;
    //       case 'title':
    //         title = right;
    //         break;
    //       case 'name':
    //         name = right;
    //         break;
    //       case 'codes':
    //         codes = right;
    //         break;
    //       case 'pricei':
    //         pricei = right;
    //         break;
    //       case 'prices':
    //         prices = right;
    //         break;
    //       case 'desc':
    //         desc = right;
    //         break;
    //       case 'email':
    //         email = right;
    //         break;
    //       case 'tw':
    //         tw = right;
    //         break;
    //       case 'ig':
    //         ig = right;
    //         break;
    //       case 'dp':
    //         imgDp = right;
    //         break;
    //     }
    //   }
    //   else{
    //     List<String> _codes = codes.split(',');
    //     temp.add(StickerArtistC(
    //         imgBatch: img,
    //         themeName: title,
    //         artist: Artist(
    //           name: name,
    //           id: '',
    //           desc: '',
    //           email: '',
    //           tw: '',
    //           fb: '',
    //           imgDp: '',
    //           ig:'',
    //         ),
    //         codes: _codes,
    //         codePrefix: getPrefix(_codes[0]),
    //         singlePrice: double.parse(pricei),
    //           setPrice: double.parse(prices),
    //           // artistDescription: desc,
    //           // email: email,
    //           // fb: fb,
    //           // tw: tw,
    //           // ig: ig,
    //           // imgDp: imgDp
    //     ));
    //     img = null;
    //     title = null;
    //     name = null;
    //     codes = null;
    //     pricei = null;
    //     prices = null;
    //     desc = null;
    //     email = null;
    //     tw = null;
    //     ig = null;
    //     fb = null;
    //     imgDp = null;
    //   }
    //   i++;
    // }
    // artistcs = temp;



    List<Artist> temp = <Artist>[];
    final artistsQuery = await firebase_firestore.getArtists();
    print('artistsQuery has length ${artistsQuery.length}');
    for (Tuple2<String, Map<String,dynamic>> artist in artistsQuery){
      temp.add(
          Artist(
            id: artist.item1,
            name: artist.item2['name'],
            desc: artist.item2['desc'],
            email: artist.item2['email'],
            fb: artist.item2['fb'],
            ig: artist.item2['ig'],
            tw: artist.item2['tw'],
            imgDp: artist.item2['dp'],)
      );
    }
    artists = temp;

    List<StickerArtistC> temp2 = <StickerArtistC>[];
    final artistsCQuery = await firebase_firestore.getArtistCs();
    for (Map<String,dynamic> c in artistsCQuery){
      DocumentReference dr =  c['artist'];
      List<String> codes = (c['codes']).split(',');
      String codePrefix = getPrefix(codes[0]);
      String drid = dr.id;
      temp2.add(
          StickerArtistC(
            artist: artists.firstWhere((element) => element.id == drid),
            codePrefix: codePrefix,
            codes:  codes,
            imgBatch: c['image'],
            setPrice: c['sprice'],
            singlePrice: c['iprice'],
            themeName: c['title']
          )
      );
    }
    artistcs = temp2;
  }

  Future<String> loadAsset(String textFile) async {
    return await rootBundle.loadString(textFile);
  }
}

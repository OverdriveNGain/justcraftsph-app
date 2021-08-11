import 'package:just_crafts_ph/classes/class_artist.dart';
import 'package:meta/meta.dart';

class StickerArtistC{
  Artist artist;
  String themeName;
  String imgBatch;
  String codePrefix;
  List<String> codes;
  double singlePrice;
  double setPrice;

  StickerArtistC({
    @required Artist artist,
    @required String themeName,
    @required String imgBatch,
    @required String codePrefix,
    @required List<String> codes,
    @required double singlePrice,
    @required double setPrice,
  }) {
    this.imgBatch = imgBatch;
    this.themeName = themeName;
    this.codes = codes;
    this.singlePrice = singlePrice;
    this.setPrice = setPrice;
    this.codePrefix = codePrefix;
    this.artist = artist;
  }
}

// class StickerArtistC{
//   String artist;
//   String artistDescription;
//   String themeName;
//   String imgDp;
//   String imgBatch;
//   String codePrefix;
//   List<String> codes;
//   double singlePrice;
//   double setPrice;
//   String email;
//   String fb;
//   String tw;
//   String ig;
//
//   /// Parameters artist, singlePrice, setPrice,  and themeName must not be null.
//   StickerArtistC({
//         String artist,
//         String artistDescription,
//         String themeName,
//         String imgDp,
//         String imgBatch,
//         String codePrefix,
//         List<String> codes,
//         double singlePrice,
//         double setPrice,
//         String email,
//         String fb,
//         String tw,
//         String ig
//       }) {
//
//     if (artist == null)
//       throw Exception('ArtistTheme(): artist must not be null');
//     if (singlePrice == null)
//       throw Exception('ArtistTheme(): singlePrice must not be null');
//     if (setPrice == null)
//       throw Exception('ArtistTheme(): setPrice must not be null');
//     if (themeName == null)
//       throw Exception('ArtistTheme(): themeName must not be null');
//
//     this.imgBatch = imgBatch;
//     this.themeName = themeName;
//     this.artist = artist;
//     this.codes = codes;
//     this.singlePrice = singlePrice;
//     this.setPrice = setPrice;
//     this.artistDescription = artistDescription;
//     this.imgDp = imgDp;
//     this.codePrefix = codePrefix;
//     this.email = email;
//     this.fb = fb;
//     this.tw = tw;
//     this.ig = ig;
//   }
// }
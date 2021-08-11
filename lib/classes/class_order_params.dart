import 'class_code_quantity.dart';
import 'package:just_crafts_ph/classes/class_smaterial.dart';
import 'package:meta/meta.dart';


abstract class OrderParams{}

class ThemeOrderParams extends OrderParams{
  String imgPreview;
  String codePrefix;
  List<CodeQuantity> codes; //comprehensive list, will include codes with quantity 0

  ThemeOrderParams({
    @required this.imgPreview,
    @required this.codePrefix,
    @required this.codes});
}

class PbjOrderParams extends OrderParams{
  String imgPreview;
  String codePrefix;
  CodeQuantity code;

  PbjOrderParams({
    @required this.imgPreview,
    @required this.codePrefix,
    @required this.code});
}

class ArtistCOrderParams extends OrderParams{
  String imgPreview;
  String codePrefix;
  List<CodeQuantity> codes; //comprehensive list, will include codes with quantity 0

  ArtistCOrderParams({
    @required this.imgPreview,
    @required this.codePrefix,
    @required this.codes});
}

class CustomOrderParams extends OrderParams{
  Smaterial smaterial;
  int pageCount;
  String downloadLinks;
  String instructions;
  String email;
  List<String> filePaths;

  CustomOrderParams({
    @required this.smaterial,
    @required this.pageCount,
    @required this.downloadLinks,
    @required this.instructions,
    @required this.filePaths,
    @required this.email});
}
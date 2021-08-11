import 'package:just_crafts_ph/classes/class_smaterial.dart';
import 'class_code_quantity.dart';
import 'package:just_crafts_ph/shared/shared_sticker_info.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart' as ioh;
import 'package:just_crafts_ph/classes/class_order_params.dart';
import 'package:just_crafts_ph/classes/class_tuple.dart';
import 'package:just_crafts_ph/txt/prices.dart' as prices;

enum OrderType { Theme, Pbj, ArtistC, Custom }

// todo: implement subclasses for each order type
class ThemeOrder extends Order{
  // String imgPreview;
  String codePrefix;
  List<CodeQuantity> codes; //comprehensive list, will include codes with quantity 0

  @override
  void _initFromParams(OrderParams op){
    assert(op is ThemeOrderParams);
    final specific = op as ThemeOrderParams;
    // imgPreview = specific.imgPreview;
    codePrefix = specific.codePrefix;
    codes = specific.codes;
  }

  @override _initFromSaveFormat(String s){
    final splits = s.substring(1 + s.indexOf(ioh.lineSeparator)).trim().split('\n').map((e) {
      int colonI = e.indexOf(':');
      return Tuple2(e.substring(0, colonI).trim(), e.substring(colonI + 1).trim());
    }).toList();
    for (int i = 0; i < splits.length; i++){
      switch(splits[i].item1){
        // case 'img_preview':
        //   imgPreview = splits[i].item2;
        //   break;
        case 'prefix':
          codePrefix = splits[i].item2;
          break;
        case 'codes':
          codes = splits[i].item2.split(',').map((e) => CodeQuantity.parse(e.trim())).toList();
          break;
        case 'unix':
          unix = splits[i].item2;
          break;
      }
    }
  }

  @override
  String toSaveFormat() {
    String temp = 'Theme\n${ioh.lineSeparator}\n';
    // temp += 'img_preview:$imgPreview\n';
    temp += 'prefix:$codePrefix\n';
    temp += 'codes:${codes.map((e) => e.toString()).join(',')}\n';
    temp += 'unix:$unix';
    return temp;
  }

  int getIndividualStickerCount() {
    int temp = 0;
    for (int i = 0; i < codes.length; i++) {
      temp += codes[i].quantity;
    }
    return temp;
  }

  @override
  String getCountText() {
    int n = getIndividualStickerCount();
    return "$n sticker${n == 1 ? "" : "s"}";
  }

  List<int> setSinglePair() {
    int minimum = 999999;
    int indivCount = 0;
    for (int i = 0; i < codes.length; i++) {
      int q = codes[i].quantity;
      indivCount += q;
      if (q < minimum) minimum = q;
    }
    indivCount -= codes.length * minimum;

    return [minimum, indivCount];
  }

  @override
  String getOrderName() => StickerInfo.st.getSetName(codePrefix, orderType);

  @override
  String getDetails() {
    int minimum = 99999;
    String temp = "";
    codes.forEach((element) {
      if (element.quantity < minimum) minimum = element.quantity;
    });
    if (minimum != 0) temp += "Full Set (x$minimum)";
    codes.forEach((element) {
      if (element.quantity - minimum > 0)
        temp +=
        "${temp == "" ? "" : ", "}${element.code} (x${element.quantity - minimum})";
    });
    return temp;
  }

  @override
  String toReadableFormat() {
    return '${orderType.toString().split('.')[1]}:\n' +
        ' - ${StickerInfo.st.getSetName(codePrefix, orderType)}\n' +
        ' - ${getDetails()}\n';
  }

  @override
  OrderType getOrderType() => OrderType.Theme;
}
class PbjOrder extends Order{
  // String imgPreview;
  String codePrefix;
  CodeQuantity codeQuantity; //comprehensive list, will include codes with quantity 0

  @override
  void _initFromParams(OrderParams op){
    assert(op is PbjOrderParams);
    final specific = op as PbjOrderParams;
    // imgPreview = specific.imgPreview;
    codePrefix = specific.codePrefix;
    codeQuantity = specific.code;
  }

  @override _initFromSaveFormat(String s){
    final splits = s.substring(1 + s.indexOf(ioh.lineSeparator)).trim().split('\n').map((e) {
      int colonI = e.indexOf(':');
      return Tuple2(e.substring(0, colonI).trim(), e.substring(colonI + 1).trim());
    }).toList();
    for (int i = 0; i < splits.length; i++){
      switch(splits[i].item1){
        // case 'img_preview':
        //   imgPreview = splits[i].item2;
        //   break;
        case 'prefix':
          codePrefix = splits[i].item2;
          break;
        case 'code':
          codeQuantity = CodeQuantity.parse(splits[i].item2);
          break;
        case 'unix':
          unix = splits[i].item2;
          break;
      }
    }
  }

  @override
  String toSaveFormat() {
    String temp = 'Pbj\n${ioh.lineSeparator}\n';
    // temp += 'img_preview:$imgPreview\n';
    temp += 'prefix:$codePrefix\n';
    temp += 'code:${codeQuantity.toString()}\n';
    temp += 'unix:$unix';
    return temp;
  }

  @override
  String getCountText() {
    int n = codeQuantity.quantity;
    return "$n set${n == 1 ? "" : "s"}";
  }

  @override
  String getOrderName() => StickerInfo.st.getSetName(codePrefix, orderType);

  @override
  String getDetails() => "x${codeQuantity.quantity}";

  @override
  String toReadableFormat() {
    return '${orderType.toString().split('.')[1]}:\n' +
        ' - ${StickerInfo.st.getSetName(codePrefix, orderType)}\n' +
        ' - ${getDetails()}\n';
  }

  @override
  OrderType getOrderType() => OrderType.Pbj;
}
class ArtistCOrder extends Order{
  // String imgPreview;
  String codePrefix;
  List<CodeQuantity> codes; //comprehensive list, will include codes with quantity 0

  @override
  void _initFromParams(OrderParams op){
    assert(op is ArtistCOrderParams);
    final specific = op as ArtistCOrderParams;
    // imgPreview = specific.imgPreview;
    codePrefix = specific.codePrefix;
    codes = specific.codes;
  }

  @override _initFromSaveFormat(String s){
    final splits = s.substring(1 + s.indexOf(ioh.lineSeparator)).trim().split('\n').map((e) {
      int colonI = e.indexOf(':');
      return Tuple2(e.substring(0, colonI).trim(), e.substring(colonI + 1).trim());
    }).toList();
    for (int i = 0; i < splits.length; i++){
      switch(splits[i].item1){
        // case 'img_preview':
        //   imgPreview = splits[i].item2;
        //   break;
        case 'prefix':
          codePrefix = splits[i].item2;
          break;
        case 'codes':
          codes = splits[i].item2.split(',').map((e) => CodeQuantity.parse(e.trim())).toList();
          break;
        case 'unix':
          unix = splits[i].item2;
          break;
      }
    }
  }

  @override
  String toSaveFormat() {
    String temp = 'ArtistC\n${ioh.lineSeparator}\n';
    // temp += 'img_preview:$imgPreview\n';
    temp += 'prefix:$codePrefix\n';
    temp += 'codes:${codes.map((e) => e.toString()).join(',')}\n';
    temp += 'unix:$unix';
    return temp;
  }

  int getIndividualStickerCount() {
    int temp = 0;
    for (int i = 0; i < codes.length; i++) {
      temp += codes[i].quantity;
    }
    return temp;
  }

  @override
  String getCountText() {
    List<int> counts = setSinglePair();
    int minimum = counts[0];
    int indivCount = counts[1];

    String setCountText =
        "${minimum > 0 ? "$minimum set${minimum == 1 ? "" : "s"}" : ""}";
    String indivCountText =
        "${indivCount > 0 ? "$indivCount single${indivCount == 1 ? "" : "s"}" : ""}";
    return "$setCountText${minimum != 0 && indivCount != 0 ? ", " : ""}$indivCountText";
  }

  List<int> setSinglePair() {
    int minimum = 999999;
    int indivCount = 0;
    for (int i = 0; i < codes.length; i++) {
      int q = codes[i].quantity;
      indivCount += q;
      if (q < minimum) minimum = q;
    }
    indivCount -= codes.length * minimum;

    return [minimum, indivCount];
  }

  @override
  String getOrderName() => StickerInfo.st.getSetName(codePrefix, orderType);

  @override
  String getDetails() {
    int minimum = 99999;
    String temp = "";
    codes.forEach((element) {
      if (element.quantity < minimum) minimum = element.quantity;
    });
    if (minimum != 0) temp += "Full Set (x$minimum)";
    codes.forEach((element) {
      if (element.quantity - minimum > 0)
        temp +=
        "${temp == "" ? "" : ", "}${element.code} (x${element.quantity - minimum})";
    });
    return temp;
  }

  @override
  String toReadableFormat() {
    return '${orderType.toString().split('.')[1]}:\n' +
        ' - ${StickerInfo.st.getSetName(codePrefix, orderType)}\n' +
        ' - ${getDetails()}\n';
  }

  @override
  OrderType getOrderType() => OrderType.ArtistC;
}
class CustomOrder extends Order{
  Smaterial smaterial;
  int pageCount;
  String instructions;

  String email;
  String downloadLinks;
  List<String> filePaths;

  @override
  void _initFromParams(OrderParams op){
    assert(op is CustomOrderParams);
    final specific = op as CustomOrderParams;
    smaterial = specific.smaterial;
    pageCount = specific.pageCount;
    downloadLinks = specific.downloadLinks;
    instructions = specific.instructions;
    filePaths = specific.filePaths;
    email = specific.email;
  }

  @override _initFromSaveFormat(String s){
    final splits = s.substring(1 + s.indexOf(ioh.lineSeparator)).trim().split(ioh.lineSeparator).map((e) {
      int colonI = e.indexOf(':');
      return Tuple2(e.substring(0, colonI).trim(), e.substring(colonI + 1).trim());
    }).toList();
    for (int i = 0; i < splits.length; i++){
      switch(splits[i].item1){
        case 'smaterial':
          final smt = Smaterial.getSmaterialType(splits[i].item2);
          smaterial =  prices.smaterials.firstWhere((element) => element.type == smt);
          break;
        case 'pageCount':
          pageCount = int.parse(splits[i].item2);
          break;
        case 'downloadLinks':
          downloadLinks = splits[i].item2;
          break;
        case 'instructions':
          instructions = splits[i].item2;
          break;
        case 'filePaths':
          filePaths = splits[i].item2.split('\n');
          break;
        case 'unix':
          unix = splits[i].item2;
          break;
        case 'email':
          unix = splits[i].item2;
          break;
        default:
          throw Exception('Unkown parameter: ${splits[i].item2}');
          break;
      }
    }
  }

  @override
  String toSaveFormat() {
    String temp = 'Custom\n';
    temp += '${ioh.lineSeparator}smaterial:${smaterial.type.toString().split('.')[1]}\n';
    temp += '${ioh.lineSeparator}pageCount:$pageCount\n';
    temp += '${ioh.lineSeparator}downloadLinks:$downloadLinks\n';
    temp += '${ioh.lineSeparator}instructions:$instructions\n';
    temp += '${ioh.lineSeparator}filePaths:${filePaths.join('\n')}\n';
    temp += '${ioh.lineSeparator}email:$email\n';
    temp += '${ioh.lineSeparator}unix:$unix';
    return temp;
  }

  @override
  String getCountText() => '${this.pageCount} sheet${this.pageCount == 1?'':'s'}';

  @override
  String getOrderName() => smaterial.name;

  @override
  String getDetails() {
    if (downloadLinks == '')
      return filePaths.map((e) => e.substring(e.lastIndexOf('/') + 1)).join('\n');
    return downloadLinks;
  }

  @override
  String toReadableFormat() {
    return '${orderType.toString().split('.')[1]}:\n' +
        ' - ${smaterial.name}\n' +
        ' - Sheets:$pageCount\n' +
        ' - Email:$email\n';
  }

  @override
  OrderType getOrderType() => OrderType.Custom;
}

abstract class Order{
  OrderType orderType;
  String unix; //millisecondsSinceEpoch

  String getUnix() => DateTime.now().millisecondsSinceEpoch.toString();

  void _initFromParams(OrderParams op);
  void _initFromSaveFormat(String s);

  OrderType getOrderType();
  String toReadableFormat();
  String toSaveFormat();

  // For order summary
  String getDetails();
  String getOrderName();
  String getCountText();

  void initFromParams(OrderParams op){
    unix = getUnix();
    orderType = getOrderType();
    _initFromParams(op);
  }
  void initFromSaveFormat(String s){
    orderType = getOrderType();
    _initFromSaveFormat(s);
  }

  static Order fromSaveFormatGeneral(String orderLine) {
    // First line should be order type, then line separator:
    List<String> vars = orderLine.split(ioh.lineSeparator);

    Order toReturn;
    switch(vars[0].trim().toLowerCase()){
      case 'theme':
        toReturn = ThemeOrder();
        break;
      case 'pbj':
        toReturn = PbjOrder();
        break;
      case 'artistc':
        toReturn = ArtistCOrder();
        break;
      case 'custom':
        toReturn = CustomOrder();
        break;
    }
    toReturn.initFromSaveFormat(orderLine);
    toReturn.orderType = toReturn.getOrderType();

    return toReturn;
    }
}
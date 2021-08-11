// import 'dart:html';
import 'dart:io';
import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/txt/discounts.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart' as ioh;

class Receipt {
  double stickerPrice;
  double shippingPrice;
  List<Order> orders;
  Address address;
  int unix;
  bool sameDayDelivery;
  Discount discount;

  double totalPrice() => stickerPrice + shippingPrice;

  Future<File> zip() async {
    String textInfo = 'ORDER INFO\n\n' +
        'Address:\n\n' +
        address.toReadableFormat() +
        '\nOrders:\n\n';
    for (int i = 0; i < orders.length; i++) {
      textInfo += orders[i].toReadableFormat() +
          (i == orders.length - 1 ? '' : '-----\n');
    }
    textInfo += '\nSticker Price: $stickerPrice\n\n';
    if (sameDayDelivery) {
      textInfo += 'Shipping Price: 0.0 (Same day delivery)\n\n';
    } else {
      textInfo += 'Shipping Price: $shippingPrice\n\n';
      textInfo += 'Total: ${totalPrice()}\n\n';
    }

    textInfo += 'Discount: ' +
        (discount == null ? 'None' : discount.toReadableFormat());
    await ioh.IoHelper.clearFolder('orderRequestsTemp');
    await ioh.IoHelper.write('orderRequestsTemp/OrderInfo.txt', textInfo);
    await ioh.IoHelper.write('orderRequestsTemp/ParsableData.txt', 'test\ntest\ntest'); // todo: Implement parsable data
    final directoryPath = (await ioh.IoHelper.getDirectory()).path;
    for (Order o in orders) {
      if (o.orderType == OrderType.Custom) {
        CustomOrder co = o;
        if (co.filePaths != null && co.filePaths.length != 0) {
          await ioh.IoHelper.newFolder('orderRequestsTemp/${o.unix}');
          for (String filepath in co.filePaths) {
            await ioh.IoHelper.copy(File(filepath),
                filepath.substring(filepath.lastIndexOf('/') + 1),
                directory: Directory('$directoryPath/orderRequestsTemp/${o.unix}'));
          }
        }
      }
    }
    File zipFile = File('$directoryPath/orderRequests/${unix}_${address.name.replaceAll(' ', '_')}.zip');
    zipFile = await zipFile.create(recursive: true);
    ioh.IoHelper.zipFromFolder(Directory('$directoryPath/orderRequestsTemp'), zipFile);
    return zipFile;
  }
}

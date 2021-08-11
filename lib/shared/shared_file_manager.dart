// Ideal file structure
//
//    /app folder
//      /orders
//        /order_02172021123456.txt
//        /order_02182021123456.txt
//        /order_02192021123456.txt
//        /order_02252021123456.txt
//      /orderRequests
//        /021520291832_Jeremy_Mattheu_D_Amon
//          ->OrderInfo.txt
//          ->ParsableData.txt
//          ->160029312983123
//            -> file 1
//            -> file 2
//          ->160029312123897
//      /addresses
//        /address_02012012398127.txt
//        /address_02172012398127.txt
//      /orderRequestsTemp


import 'dart:io';
import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart';

class FileManager {
  static FileManager _st;

  static get st {
    if (_st == null) _st = FileManager();
    return _st;
  }

  List<Order> orders = List<Order>.generate(0, (index) => null);
  List<Address> addresses = List<Address>.generate(0, (index) => null);

  void addOrder(Order order) {
    orders.add(order);
    saveOrders();
  }
  Future<bool> loadOrders() async {
    try{
      orders.clear();

      final children = await IoHelper.children('orders');
      for (int i = 0; i < children.length; i++){
        FileSystemEntity child = children[i];
        if (child is File){
          String toParse = await child.readAsString();
          orders.add(Order.fromSaveFormatGeneral(toParse));
        }
      }
      return true;
    }
    catch(e){
      print('Cannot load orders.');
      print(e);
      return false;
    }

  }
  Future<bool> saveOrders() async {
    if (orders == null)
      return false;

    List<String> done = [];
    // writes and overwrites
    for (int i = 0; i < orders.length; i++) {
      String toSave = orders[i].toSaveFormat();
      await IoHelper.write('orders/order_${orders[i].unix}.txt', toSave);
      done.add('order_${orders[i].unix}.txt');
    }
    // deletions
    print('done list:');
    for (String s in done){
      print(s);
    }
    final children = (await IoHelper.children('orders')).map((e) => e.path.substring(e.path.lastIndexOf('/') + 1));
    for (String child in children){
      if (!(done.contains(child)))
        IoHelper.delete('orders/$child');
    }
    return true;
  }
  Future<bool> updateOrder(Order order) async{
    try{
      for(int i = 0; i < orders.length; i++){
        if (orders[i].unix == order.unix){
          orders[i] = order;
          await saveOrders();
          return true;
        }
      }
      print('Cannot update order. Order not found.');
      return false;
    }
    catch(e){
      print('Cannot update order.');
      print(e);
      return false;
    }
  }

  // todo: implement try and future model in user_info methods
  Future<bool> addAddress(Address address) async {
    addresses.add(address);
    try{
      await saveAddresses();
      return true;
    }
    catch (e){
      addresses.removeLast();
      print('Failed addAddresses()');
      print(e.toString());
      return false;
    }
  }
  Future<bool> saveAddresses() async {
    if (orders == null)
      return false;

    for (int i = 0; i < addresses.length; i++) {
      String toSave = addresses[i].toSaveFormat();
      await IoHelper.write('addresses/address_${addresses[i].unix}.txt', toSave);
    }
    return true;
  }
  Future<bool> loadAddresses() async{
    addresses.clear();

    final children = await IoHelper.children('addresses');
    for (int i = 0; i < children.length; i++){
      FileSystemEntity child = children[i];
      if (child is File){
        String toParse = await child.readAsString();
        addresses.add(Address.fromSaveFormat(toParse));
      }
    }

    return true;
  }
  Future<String> readAddresses() async{
    String strFromFile;
    try{
      strFromFile = await IoHelper.read('addressinfo.txt');
      return strFromFile;
    }
    catch(e) {
      print(e);
      return '';
    }
  }
  Future<bool> deleteAddresses() async {
    try{
      await IoHelper.delete('addressinfo.txt');
      addresses.clear();
      return true;
    }
    catch (e){
      print(e);
      return false;
    }
  }

  Future<bool> initFolders() async {
    try{
      await IoHelper.newFolder('orders');
      await IoHelper.newFolder('orderRequests');
      await IoHelper.newFolder('addresses');
      await IoHelper.newFolder('orderRequestsTemp');
      return true;
    }
    catch(e){
      return false;
    }
  }




}
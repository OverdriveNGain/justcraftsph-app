import 'package:equatable/equatable.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart' as ioh;
import 'package:meta/meta.dart';
//import 'package:just_crafts_ph/shared/shared_file_manager.dart';

enum Region { MetroManila, NorthLuzon, SouthLuzon, Visayas, Mindanao, Overseas }

class Address extends Equatable{
  final String name;
  final String number;
  final String address;
  final String deliveryInstructions;
  final String email;
  final Region region;
  final String unix;

  Address({
    @required this.name,
    @required this.number,
    @required this.address,
    @required this.region,
    @required this.deliveryInstructions,
    @required this.email,
    @required this.unix});

  @override
  List<String> get props => [name, number, address, deliveryInstructions, email, region.toString()];

  String toSaveFormat() {
    String temp = 'ADDRESS\n';
    temp += '${ioh.lineSeparator}NAM:$name\n';
    temp += '${ioh.lineSeparator}NUM:${number.toString()}\n';
    temp += '${ioh.lineSeparator}EMA:$email\n';
    temp += '${ioh.lineSeparator}REG:${region.toString()}\n';
    temp += '${ioh.lineSeparator}ADR:$address\n';
    temp += '${ioh.lineSeparator}DIN:$deliveryInstructions\n';
    temp += '${ioh.lineSeparator}TIM:$unix';
    return temp;
  }

  static Address fromSaveFormat(String s) {
    s = s.substring(1 + s.indexOf(ioh.lineSeparator)).trim();
    List<String> lines = s.split(ioh.lineSeparator).map((e) => e.trim().substring(4)).toList();
    print('fromSaveFormat()');
    print(lines);
    return Address(
      name: lines[0],
      number: lines[1],
      email: lines[2],
      region: _regionFromString(lines[3]),
      address: lines[4],
      deliveryInstructions: lines[5],
      unix: lines[6]
    );
  }

  String toReadableFormat(){
    return 'Name: ${this.name}\n'+
        'Region: ${Address.displayStringFromRegion(this.region)}\n'+
        'Address: ${this.address}\n'+
        'Email: ${this.email == ''?'None':this.email}\n'+
        'Number: ${this.number}\n'+
        'Delivery Instructions: ${this.deliveryInstructions == ''?'None':this.deliveryInstructions}\n';
  }




  static Region _regionFromString(String s) {
    switch (s) {
      case 'Region.MetroManila':
        return Region.MetroManila;
      case 'Region.Mindanao':
        return Region.Mindanao;
      case 'Region.NorthLuzon':
        return Region.NorthLuzon;
      case 'Region.SouthLuzon':
        return Region.SouthLuzon;
      case 'Region.Overseas':
        return Region.Overseas;
      case 'Region.Visayas':
        return Region.Visayas;
    }
    return null;
  }

  static String displayStringFromRegion(Region r) {
    switch (r) {
      case Region.MetroManila:
        return 'Metro Manila';
      case Region.Mindanao:
        return 'Mindanao';
      case Region.NorthLuzon:
        return 'North Luzon';
      case Region.SouthLuzon:
        return 'South Luzon';
      case Region.Overseas:
        return 'Overseas';
      case Region.Visayas:
        return 'Visayas';
    }
    return null;
  }
}

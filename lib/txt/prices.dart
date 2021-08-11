import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/classes/class_smaterial.dart';

double themePrice5 = 40;
double themePrice10 = 70;
double themePrice15 = 90;
double themePrice20 = 100;
double themePriceAbove = 5;

int pbjPackCount = 3;
double pbjPackPrice = 100;
double pbjSinglePrice = 30;

double shippingMmanila = 40;
double shippingNluzon = 160;
double shippingSluzon = 160;
double shippingVisayas = 160;
double shippingMindanao = 160;
double shippingOverseas = 1000;

int customBulkCountMinimum = 5;
// todo: put all these info in a database

List<Smaterial> smaterials = [
  Smaterial(
      type: SmaterialType.Glossy,
      name: 'Glossy',
      waterResistant: false,
      waterProof: false,
      scratchResistant: false,
      writable: true,
      textured: false,
      retailPrice: 75,
      bulkPrice: 50),
  Smaterial(
      type: SmaterialType.Standard,
      name: 'Standard',
      waterResistant: true,
      waterProof: true,
      scratchResistant: false,
      writable: false,
      textured: false,
      retailPrice: 120,
      bulkPrice: 60),
  Smaterial(
      type: SmaterialType.Semiclear,
      name: 'Semiclear',
      waterResistant: true,
      waterProof: true,
      scratchResistant: false,
      writable: false,
      textured: false,
      retailPrice: 120,
      bulkPrice: 60),
  Smaterial(
      type: SmaterialType.LaminatedGlossy,
      name: 'Laminated Glossy',
      waterResistant: true,
      waterProof: false,
      scratchResistant: true,
      writable: false,
      textured: true,
      retailPrice: 120,
      bulkPrice: 60),
  Smaterial(
      type: SmaterialType.LaminatedStandard,
      name: 'Laminated Standard',
      waterResistant: true,
      waterProof: true,
      scratchResistant: true,
      writable: false,
      textured: true,
      retailPrice: 150,
      bulkPrice: 80),
  Smaterial(
      type: SmaterialType.LaminatedSemiclear,
      name: 'Laminated Semiclear',
      waterResistant: true,
      waterProof: true,
      scratchResistant: true,
      writable: false,
      textured: true,
      retailPrice: 150,
      bulkPrice: 80),
];

double getShippingFee(Region r) {
  switch (r) {
    case Region.Overseas:
      return shippingOverseas;
    case Region.MetroManila:
      return shippingMmanila;
    case Region.Visayas:
      return shippingVisayas;
    case Region.SouthLuzon:
      return shippingSluzon;
    case Region.Mindanao:
      return shippingMindanao;
    case Region.NorthLuzon:
      return shippingNluzon;
    case Region.SouthLuzon:
      return shippingSluzon;
    default:
      return -999999;
  }
}

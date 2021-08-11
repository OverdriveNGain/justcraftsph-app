// todo: implement this on cloud

// import 'package:just_crafts_ph/classes/class_address.dart';
// import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/classes/class_receipt.dart';
import 'package:meta/meta.dart';

enum DeliveryType{Standard, SameDay}

abstract class Validity{
  bool isValid(Receipt receipt);
}
class TimeFrameValidity extends Validity{
  // final validityType = ValidityType.TimeFrame;
  int startUnix;
  int endUnix;

  TimeFrameValidity({
    @required this.startUnix,
    @required this.endUnix
  });

  @override
  bool isValid(Receipt receipt) => startUnix <= receipt.unix &&  receipt.unix <= endUnix;
}
class LimitedUsesValidity extends Validity{
  // final validityType = ValidityType.LimitedUses;
  @override
  bool isValid(Receipt receipt) => true; //todo: implement to read database numbers
}
class MinimumPriceValidity extends Validity{
  // final validityType = ValidityType.MinimumPrice;
  double minimum; //Inclusive
  bool factorInStickers;
  bool factorInShipping;

  MinimumPriceValidity({
    @required this.minimum,
    @required this.factorInStickers,
    @required this.factorInShipping
  });

  @override
  bool isValid(Receipt receipt) =>
      ((factorInStickers?1:0) * receipt.stickerPrice) + ((factorInShipping?1:0) * receipt.shippingPrice) >= minimum;
}
class DeliveryOptionValidity extends Validity{
  DeliveryType option; //Inclusive

  DeliveryOptionValidity({
    @required this.option,
  });

  @override
  bool isValid(Receipt receipt) =>
      option == DeliveryType.Standard?
      receipt.sameDayDelivery == false:
      receipt.sameDayDelivery == true;
}

// enum DiscountCalculationType{Percentage, Discrete}
abstract class DiscountCalculation{
  double calculateNewPrice(Receipt receipt);
}
class PercentageDiscountCalculation extends DiscountCalculation{
  double percentage;
  bool factorInStickers;
  bool factorInShipping;

  PercentageDiscountCalculation({
    @required this.percentage,
    @required this.factorInStickers,
    @required this.factorInShipping});

  @override
  double calculateNewPrice(Receipt receipt) {
    return (factorInStickers?(1 - percentage):1) * receipt.stickerPrice + (factorInShipping?(1 - percentage):1) * receipt.shippingPrice;
  }
}
class DiscreteDiscountCalculation extends DiscountCalculation{
  double less;

  DiscreteDiscountCalculation({
    @required this.less});

  @override
  double calculateNewPrice(Receipt receipt) => receipt.totalPrice() - less;
}

class Discount{
  List<Validity> validity;
  DiscountCalculation discountCalculation;
  String code;
  String description;

  Discount({
    @required this.code,
    @required this.validity,
    @required this.discountCalculation,
    @required this.description});

  bool isValid(Receipt receipt){
    for(Validity v in validity)
      if (!v.isValid(receipt))
        return false;
    return true;
  }
  double getNewPrice(Receipt receipt) => discountCalculation.calculateNewPrice(receipt);

  String toReadableFormat() {
    //todo: implement to readable format in discounts
    return 'toImplement';
  }
}

Discount sample1 = Discount(
  code: 'SAMPLE1',
  description: 'This is for debugging purposes only. If you see this in the final app, please let us know. Thanks!',
  discountCalculation: DiscreteDiscountCalculation(less: 30),
  validity: [
    MinimumPriceValidity(
      minimum: 200,
      factorInShipping: false,
      factorInStickers: false,
    )
  ]
);
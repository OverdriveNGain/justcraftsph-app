class CodeQuantity{
  final String code;
  int quantity;

  CodeQuantity(this.code, this.quantity);

  String toString(){
    return '($code:$quantity)';
  }

  static CodeQuantity parse(String s){
    final a = s.substring(1, s.length - 1).split(':');
    return CodeQuantity(a[0].trim(), int.parse(a[1]));
  }
}
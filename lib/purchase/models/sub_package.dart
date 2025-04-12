class SubPackage {
  final int percentDiscount;
  final double months;
  final double price;
  final String keyStoreIOS;
  final String keyStoreAndroid;
  final String name;

  SubPackage({
    this.percentDiscount = 0,
    required this.months,
    required this.price,
    required this.keyStoreAndroid,
    required this.keyStoreIOS,
    required this.name,
  });
}
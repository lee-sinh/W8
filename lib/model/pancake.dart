class Pancake {
  final String? id;
  final String color;
  final double price;

  Pancake({this.id, required this.color, required this.price});

  @override
  bool operator ==(Object other) {
    return other is Pancake && other.id == id;
  }

  Pancake copyWith({String? color, double? price}) {
    return Pancake(
      color: color ?? this.color,
      price: price ?? this.price,
    );
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}

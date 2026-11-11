import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_count.g.dart';

@Riverpod(keepAlive: true)
class CartCount extends _$CartCount {
  @override
  int build() => 0;

  void add(int quantity) => state += quantity;
}

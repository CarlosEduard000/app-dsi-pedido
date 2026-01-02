import 'package:flutter_riverpod/legacy.dart';
import '../../../articles/domain/domain.dart';

class OrderItem {
  final Article article;
  final int quantity;

  OrderItem({required this.article, required this.quantity});
}

class OrderDraftState {
  final Map<String, OrderItem> items;

  OrderDraftState({this.items = const {}});

  double get totalAmount => items.values.fold(
    0,
    (sum, item) => sum + (item.article.price * item.quantity),
  );

  int get totalItems => items.length;

  int get totalUnits =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  OrderDraftState copyWith({Map<String, OrderItem>? items}) =>
      OrderDraftState(items: items ?? this.items);
}

class OrderDraftNotifier extends StateNotifier<OrderDraftState> {
  OrderDraftNotifier() : super(OrderDraftState());

  void addOrUpdateItem(Article article, int quantity) {
    if (quantity <= 0) {
      removeItem(article.id);
      return;
    }

    final newItems = Map<String, OrderItem>.from(state.items);
    newItems[article.id] = OrderItem(article: article, quantity: quantity);
    state = state.copyWith(items: newItems);
  }

  void removeItem(String articleId) {
    if (!state.items.containsKey(articleId)) return;
    final newItems = Map<String, OrderItem>.from(state.items);
    newItems.remove(articleId);
    state = state.copyWith(items: newItems);
  }

  void clearOrder() {
    state = OrderDraftState();
  }
}

final orderDraftProvider =
    StateNotifierProvider<OrderDraftNotifier, OrderDraftState>((ref) {
      return OrderDraftNotifier();
    });

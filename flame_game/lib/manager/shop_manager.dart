class ShopManager {
  List<Map<String, dynamic>> availableItems = [];
  Map<String, int> purchasedItems = {};

  ShopManager() {
    _initShop();
  }

  void _initShop() {
    availableItems = [
      {
        'id': 'hp_potion',
        'name': '體力藥水',
        'description': '恢復50點體力',
        'price': 100,
        'type': 'consumable',
      },
      {
        'id': 'mp_potion',
        'name': '靈感藥水',
        'description': '恢復50點靈感',
        'price': 100,
        'type': 'consumable',
      },
      {
        'id': 'lucky_charm',
        'name': '幸運符',
        'description': '增加事件觸發機率',
        'price': 200,
        'type': 'buff',
      },
    ];
  }

  List<Map<String, dynamic>> getAvailableItems() {
    return availableItems;
  }

  Map<String, int> getPurchasedItems() {
    return purchasedItems;
  }

  bool purchaseItem(String itemId) {
    final item = availableItems.firstWhere(
      (item) => item['id'] == itemId,
      orElse: () => {},
    );

    if (item.isEmpty) return false;

    purchasedItems[itemId] = (purchasedItems[itemId] ?? 0) + 1;
    return true;
  }

  bool useItem(String itemId) {
    if (purchasedItems[itemId] == null || purchasedItems[itemId]! <= 0) {
      return false;
    }

    purchasedItems[itemId] = purchasedItems[itemId]! - 1;
    if (purchasedItems[itemId]! <= 0) {
      purchasedItems.remove(itemId);
    }
    return true;
  }

  int getItemCount(String itemId) {
    return purchasedItems[itemId] ?? 0;
  }

  void resetShop() {
    purchasedItems.clear();
  }
} 
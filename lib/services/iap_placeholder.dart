/// In-app purchase placeholder. Range Safety owns store/IAP/legal gates.
/// Do not wire store submit or merch IAP in this scaffold.
class IapPlaceholder {
  const IapPlaceholder();

  Future<bool> restorePurchases() async => false;

  Future<void> purchasePlan(String productId) async {
    throw UnimplementedError('IAP not wired — Range Safety owns store gates');
  }
}

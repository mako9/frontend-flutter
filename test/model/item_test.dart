import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_flutter/model/item.dart';

/// `requiresApproval` is the one field whose *absent* value is a decision: since 2026-11-23 lending here
/// needs the owner's yes, so a payload that says nothing must not quietly opt the item out. The server's
/// own defaults say the same (ItemRequestDto / ItemModel / changelog-3.1.sql).
void main() {
  test(
      'when building an item without touching approval, then approval is required',
      () {
    expect(Item(name: 'pressure washer').requiresApproval, isTrue);
  });

  test(
      'when parsing an item without the approval field, then approval is required',
      () {
    final item = Item.fromJson({
      'uuid': 'i1',
      'name': 'pressure washer',
      'categories': ['TOOL'],
    });

    expect(item.requiresApproval, isTrue);
  });

  test(
      'when parsing an item whose owner switched approval off, then it stays off',
      () {
    final item = Item.fromJson({
      'uuid': 'i1',
      'name': 'ladder',
      'requiresApproval': false,
    });

    expect(item.requiresApproval, isFalse);
  });
}

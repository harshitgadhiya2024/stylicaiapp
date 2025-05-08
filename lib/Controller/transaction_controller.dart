// transaction_controller.dart
import 'package:get/get.dart';

import '../Model/transaction_model.dart';
import '../Utills/globle_variable.dart';
import '../Utills/transaction_service.dart';

class TransactionController extends GetxController {
  final TransactionService _service = TransactionService();

  var isLoading = false.obs;
  var transactions = <Transaction>[].obs;
  var errorMessage = ''.obs;
  var timestamp = ''.obs;

  Future<void> fetchTransactionHistory() async {
    try {
      await GlobleVariables.loadSavedUserId();
      final userId = GlobleVariables.userId;

      isLoading(true);
      errorMessage('');

      final response = await _service.getTransactionHistory(userId);

      transactions.assignAll(response.data);
      timestamp.value = response.timestamp;

    } catch (e) {
      errorMessage('Failed to load transactions: $e');
    } finally {
      isLoading(false);
    }
  }

  String getCoinTypeIcon(String coinType) {
    switch (coinType) {
      case 'photo_coin':
        return '📸';
      case 'photoshoot_coin':
        return '🎬';
      default:
        return '🪙';
    }
  }

  String formatCoinType(String coinType) {
    return coinType
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
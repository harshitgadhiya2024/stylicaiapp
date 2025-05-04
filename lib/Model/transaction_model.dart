// transaction_model.dart
class TransactionHistoryResponse {
  final List<Transaction> data;
  final int status;
  final String timestamp;

  TransactionHistoryResponse({
    required this.data,
    required this.status,
    required this.timestamp,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      data: (json['data'] as List).map((item) => Transaction.fromJson(item)).toList(),
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }
}

class Transaction {
  final String balanceType;
  final String coinType;
  final int credits;
  final String notes;

  Transaction({
    required this.balanceType,
    required this.coinType,
    required this.credits,
    required this.notes,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      balanceType: json['balance_type'],
      coinType: json['coin_type'],
      credits: json['credits'],
      notes: json['notes'],
    );
  }
}
// transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/transaction_model.dart';

class TransactionService {
  final String baseUrl = 'https://backendapp.stylic.ai';

  Future<TransactionHistoryResponse> getTransactionHistory(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/stylic/get_transaction_history');

      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = userId;

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return TransactionHistoryResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load transaction history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transaction history: $e');
    }
  }
}
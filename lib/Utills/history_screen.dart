// transaction_history_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylicai/Utills/globle_variable.dart';

import '../Controller/transaction_controller.dart';
import 'app_color.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionController controller = Get.put(TransactionController());
  final String userId = GlobleVariables.userId; // Example user ID

  @override
  void initState() {
    super.initState();
    controller.fetchTransactionHistory(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchTransactionHistory(userId),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.transactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions found',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Column(
          children: [
            SizedBox(height: 60,),
            Text("Transactions History", style: TextStyle(fontSize: 24, color: AppColor.textColor, fontWeight: FontWeight.bold),),
            // Timestamp display
            if (controller.timestamp.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Last updated: ${controller.timestamp.value}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),

            // Transaction list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = controller.transactions[index];
                  final bool isAddition = transaction.balanceType == 'add';
                  final bool iscointype = transaction.coinType.toLowerCase() == 'photo_coin';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: iscointype ? Container(
                              height:20,
                              width: 20,
                              child: Image.asset("assets/images/single_coin.png")) : Container(
                            height: 20,
                              width: 20,
                              child: Image.asset("assets/images/multi_coin.png")),
                        ),
                        title: Text(
                          controller.formatCoinType(transaction.coinType),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          transaction.notes,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '${isAddition ? '+' : '-'}${transaction.credits}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isAddition ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
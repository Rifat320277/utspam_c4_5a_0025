import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/transaction.dart' as model;
import '../helpers/database_helper.dart';
import 'purchase_detail_page.dart';

class PurchaseHistoryPage extends StatefulWidget {
  final User user;

  const PurchaseHistoryPage({super.key, required this.user});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<model.Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final transactions = await DatabaseHelper.instance.getTransactionsByUserId(
      widget.user.id!,
    );
    setState(() {
      _transactions = transactions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF21004B),
        title: const Text(
          'Purchase History',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF21004B)),
            )
          : _transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No purchase history',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF21004B),
              onRefresh: _loadTransactions,
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionCard(transaction);
                },
              ),
            ),
    );
  }

  Widget _buildTransactionCard(model.Transaction transaction) {
    final date = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).format(DateTime.parse(transaction.purchaseDate));
    final isCancelled = transaction.status == 'Cancelled';

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseDetailPage(
              transactionId: transaction.id!,
              user: widget.user,
            ),
          ),
        );
        _loadTransactions();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCancelled ? Colors.grey : const Color(0xFF21004B),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.medicineName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? Colors.grey
                          : const Color(0xFF21004B),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? Colors.grey.withOpacity(0.1)
                        : const Color(0xFF21004B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? Colors.grey
                          : const Color(0xFF21004B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              transaction.medicineCategory,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buyer',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaction.buyerName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF21004B),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.quantity}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF21004B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  'Rp ${transaction.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF21004B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

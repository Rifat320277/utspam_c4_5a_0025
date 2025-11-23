import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/transaction.dart' as model;
import '../helpers/database_helper.dart';
import 'edit_transaction_page.dart';

class PurchaseDetailPage extends StatefulWidget {
  final int transactionId;
  final User user;

  const PurchaseDetailPage({
    super.key,
    required this.transactionId,
    required this.user,
  });

  @override
  State<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseDetailPage> {
  model.Transaction? _transaction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    final transaction = await DatabaseHelper.instance.getTransactionById(
      widget.transactionId,
    );
    setState(() {
      _transaction = transaction;
      _isLoading = false;
    });
  }

  Future<void> _cancelTransaction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Cancel Transaction',
          style: TextStyle(color: Color(0xFF21004B)),
        ),
        content: const Text(
          'Are you sure you want to cancel this transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes',
              style: TextStyle(color: Color(0xFF21004B)),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && _transaction != null) {
      final updatedTransaction = _transaction!.copyWith(status: 'Cancelled');
      await DatabaseHelper.instance.updateTransaction(updatedTransaction);
      _loadTransaction();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction cancelled')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF21004B),
        title: const Text(
          'Purchase Detail',
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
          : _transaction == null
          ? const Center(child: Text('Transaction not found'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21004B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF21004B)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transaction ID',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${_transaction!.id.toString().padLeft(6, '0')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF21004B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      'Medicine Name',
                      _transaction!.medicineName,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Category', _transaction!.medicineCategory),
                    const SizedBox(height: 16),
                    _buildDetailRow('Buyer Name', _transaction!.buyerName),
                    const SizedBox(height: 16),
                    _buildDetailRow('Quantity', '${_transaction!.quantity}x'),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Unit Price',
                      'Rp ${_transaction!.medicinePrice.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Total Price',
                      'Rp ${_transaction!.totalPrice.toStringAsFixed(0)}',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Purchase Date',
                      DateFormat(
                        'dd MMMM yyyy, HH:mm',
                      ).format(DateTime.parse(_transaction!.purchaseDate)),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Purchase Method',
                      _transaction!.purchaseMethod,
                    ),
                    if (_transaction!.prescriptionNumber != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Prescription Number',
                        _transaction!.prescriptionNumber!,
                      ),
                    ],
                    if (_transaction!.notes != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow('Notes', _transaction!.notes!),
                    ],
                    const SizedBox(height: 16),
                    _buildDetailRow('Status', _transaction!.status),
                    const SizedBox(height: 32),
                    if (_transaction!.status != 'Cancelled') ...[
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTransactionPage(
                                  transaction: _transaction!,
                                  user: widget.user,
                                ),
                              ),
                            );
                            _loadTransaction();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF21004B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Edit Transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _cancelTransaction,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel Transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF21004B)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF21004B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

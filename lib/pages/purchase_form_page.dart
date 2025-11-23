import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/medicine.dart';
import '../models/transaction.dart' as model;
import '../helpers/database_helper.dart';

class PurchaseFormPage extends StatefulWidget {
  final User user;
  final Medicine? medicine;

  const PurchaseFormPage({super.key, required this.user, this.medicine});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _buyerNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final _prescriptionController = TextEditingController();

  Medicine? _selectedMedicine;
  String _purchaseMethod = 'Direct Purchase';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedMedicine = widget.medicine;
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitPurchase() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedMedicine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a medicine')));
      return;
    }

    setState(() => _isLoading = true);

    final quantity = int.parse(_quantityController.text);
    final totalPrice = _selectedMedicine!.price * quantity;

    final transaction = model.Transaction(
      userId: widget.user.id!,
      medicineId: _selectedMedicine!.id,
      medicineName: _selectedMedicine!.name,
      medicineCategory: _selectedMedicine!.category,
      medicinePrice: _selectedMedicine!.price,
      buyerName: _buyerNameController.text,
      quantity: quantity,
      totalPrice: totalPrice,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      purchaseMethod: _purchaseMethod,
      prescriptionNumber: _purchaseMethod == 'Prescription Purchase'
          ? _prescriptionController.text
          : null,
      purchaseDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      status: 'Completed',
    );

    await DatabaseHelper.instance.createTransaction(transaction);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Purchase successful')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF21004B),
        title: const Text(
          'Purchase Medicine',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Medicine',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21004B),
                  ),
                ),
                const SizedBox(height: 8),
                if (_selectedMedicine != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF21004B)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF21004B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _selectedMedicine!.image,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedMedicine!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF21004B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedMedicine!.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${_selectedMedicine!.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF21004B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.medicine == null)
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF21004B),
                            ),
                            onPressed: () {
                              _showMedicineSelector();
                            },
                          ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: _showMedicineSelector,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF21004B)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tap to select medicine',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _buyerNameController,
                  decoration: InputDecoration(
                    labelText: 'Buyer Name',
                    labelStyle: const TextStyle(color: Color(0xFF21004B)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF21004B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF21004B),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Buyer name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: const TextStyle(color: Color(0xFF21004B)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF21004B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF21004B),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quantity is required';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Quantity must be a positive number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    labelStyle: const TextStyle(color: Color(0xFF21004B)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF21004B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF21004B),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Purchase Method',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF21004B),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Direct Purchase'),
                      value: 'Direct Purchase',
                      groupValue: _purchaseMethod,
                      activeColor: const Color(0xFF21004B),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _purchaseMethod = value!;
                          _prescriptionController.clear();
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Prescription Purchase'),
                      value: 'Prescription Purchase',
                      groupValue: _purchaseMethod,
                      activeColor: const Color(0xFF21004B),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _purchaseMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
                if (_purchaseMethod == 'Prescription Purchase') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Prescription Number',
                      labelStyle: const TextStyle(color: Color(0xFF21004B)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF21004B)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF21004B),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_purchaseMethod == 'Prescription Purchase') {
                        if (value == null || value.isEmpty) {
                          return 'Prescription number is required';
                        }
                        if (value.length < 6) {
                          return 'Prescription number must be at least 6 characters';
                        }
                        if (!RegExp(
                          r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                        ).hasMatch(value)) {
                          return 'Prescription number must contain letters and numbers';
                        }
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 32),
                if (_selectedMedicine != null &&
                    _quantityController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21004B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF21004B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${(_selectedMedicine!.price * (int.tryParse(_quantityController.text) ?? 0)).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF21004B),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitPurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21004B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Purchase',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMedicineSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Medicine',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF21004B),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: Medicine.dummyData.length,
                  itemBuilder: (context, index) {
                    final medicine = Medicine.dummyData[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMedicine = medicine;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF21004B)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF21004B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  medicine.image,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medicine.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF21004B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    medicine.category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${medicine.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF21004B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Transaction {
  final int? id;
  final int userId;
  final int medicineId;
  final String medicineName;
  final String medicineCategory;
  final double medicinePrice;
  final String buyerName;
  final int quantity;
  final double totalPrice;
  final String? notes;
  final String purchaseMethod;
  final String? prescriptionNumber;
  final String purchaseDate;
  final String status;

  Transaction({
    this.id,
    required this.userId,
    required this.medicineId,
    required this.medicineName,
    required this.medicineCategory,
    required this.medicinePrice,
    required this.buyerName,
    required this.quantity,
    required this.totalPrice,
    this.notes,
    required this.purchaseMethod,
    this.prescriptionNumber,
    required this.purchaseDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'medicineCategory': medicineCategory,
      'medicinePrice': medicinePrice,
      'buyerName': buyerName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'notes': notes,
      'purchaseMethod': purchaseMethod,
      'prescriptionNumber': prescriptionNumber,
      'purchaseDate': purchaseDate,
      'status': status,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      userId: map['userId'],
      medicineId: map['medicineId'],
      medicineName: map['medicineName'],
      medicineCategory: map['medicineCategory'],
      medicinePrice: map['medicinePrice'],
      buyerName: map['buyerName'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      notes: map['notes'],
      purchaseMethod: map['purchaseMethod'],
      prescriptionNumber: map['prescriptionNumber'],
      purchaseDate: map['purchaseDate'],
      status: map['status'],
    );
  }

  Transaction copyWith({
    int? id,
    int? userId,
    int? medicineId,
    String? medicineName,
    String? medicineCategory,
    double? medicinePrice,
    String? buyerName,
    int? quantity,
    double? totalPrice,
    String? notes,
    String? purchaseMethod,
    String? prescriptionNumber,
    String? purchaseDate,
    String? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      medicineCategory: medicineCategory ?? this.medicineCategory,
      medicinePrice: medicinePrice ?? this.medicinePrice,
      buyerName: buyerName ?? this.buyerName,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      purchaseMethod: purchaseMethod ?? this.purchaseMethod,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
    );
  }
}

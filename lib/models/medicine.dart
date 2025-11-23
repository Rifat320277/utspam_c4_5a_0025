class Medicine {
  final int id;
  final String name;
  final String category;
  final String image;
  final double price;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
  });

  static List<Medicine> dummyData = [
    Medicine(
      id: 1,
      name: 'Paracetamol',
      category: 'Analgesic',
      image: '💊',
      price: 15000,
    ),
    Medicine(
      id: 2,
      name: 'Amoxicillin',
      category: 'Antibiotic',
      image: '💊',
      price: 45000,
    ),
    Medicine(
      id: 3,
      name: 'Vitamin C',
      category: 'Vitamin',
      image: '💊',
      price: 25000,
    ),
    Medicine(
      id: 4,
      name: 'Ibuprofen',
      category: 'Analgesic',
      image: '💊',
      price: 20000,
    ),
    Medicine(
      id: 5,
      name: 'Betadine',
      category: 'Antiseptic',
      image: '💊',
      price: 35000,
    ),
    Medicine(
      id: 6,
      name: 'Vitamin D3',
      category: 'Vitamin',
      image: '💊',
      price: 50000,
    ),
    Medicine(
      id: 7,
      name: 'Cefixime',
      category: 'Antibiotic',
      image: '💊',
      price: 65000,
    ),
    Medicine(
      id: 8,
      name: 'Antasida',
      category: 'Antacid',
      image: '💊',
      price: 18000,
    ),
  ];
}

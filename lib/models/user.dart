class User {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String username;
  final String password;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      username: map['username'],
      password: map['password'],
    );
  }
}

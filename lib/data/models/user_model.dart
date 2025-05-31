class User {
  final int id;
  final String? nip;
  final String name;
  final String email;
  final String? phone;
  final String? gender;
  final String group; // user, admin, superadmin
  // Tambahkan field lain jika diperlukan (education, division, job_title)

  User({
    required this.id,
    this.nip,
    required this.name,
    required this.email,
    this.phone,
    this.gender,
    required this.group,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nip: json['nip'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      group: json['group'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nip': nip,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'group': group,
    };
  }
}

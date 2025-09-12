class Contact {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final bool isFavorite;
  final DateTime createdAt;

  Contact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.isFavorite,
    required this.createdAt,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json['id'],
    userId: json['user_id'],
    name: json['name'],
    phone: json['phone'],
    isFavorite: json['is_favorite'] ?? false,
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toInsert() => {
    'name': name,
    'phone': phone,
    'is_favorite': isFavorite,
  };

  Contact copyWith({String? name, String? phone, bool? isFavorite}) => Contact(
    id: id,
    userId: userId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt,
  );
}

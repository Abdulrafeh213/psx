class Listing {
  final String id;
  final String userId; // link with users table
  final String title;
  final String category; // e.g., Mobile, MotorBikes, etc.
  final double price; // in Rs
  final String imageUrl;
  final bool featured;
  final DateTime createdAt;
  final String condition; // New/Used
  final String locationName;

  Listing({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.featured,
    required this.createdAt,
    required this.condition,
    required this.locationName,
  });

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['image_url'] ?? '',
      featured: map['featured'] ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      condition: map['condition'] ?? 'Used',
      locationName: map['location_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'featured': featured,
      'created_at': createdAt.toIso8601String(),
      'condition': condition,
      'location_name': locationName,
    };
  }
}

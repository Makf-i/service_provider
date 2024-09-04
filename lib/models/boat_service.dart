class BoatService {
  final String id;
  final bool isSelected;
  final String serviceName;
  final String description;
  final String rate;
  final String image;
  final String avlbSeats;
  final String? details;
  final List<String>? amenities;
  final List<String>? safetyFeatures;
  final List<String>? specialNotes;
  final List<String>? meals;

  BoatService({
    required this.id,
    this.isSelected = false,
    required this.serviceName,
    required this.description,
    required this.rate,
    required this.image,
    required this.avlbSeats,
    this.details,
    this.amenities,
    this.safetyFeatures,
    this.specialNotes,
    this.meals,
  });

  //this method will convert dynamic into BoatService

  factory BoatService.fromMap(String id, Map<String, dynamic> data) {
    return BoatService(
      id: id,
      isSelected: data['isSelected'] ?? false,
      serviceName: data['service_name'] ?? '',
      description: data['description'] ?? '',
      rate: data['rate'] ?? '',
      image: data['image'] ?? '',
      avlbSeats: data['avlbSeats'] ?? '',
      details: data['details'],
      amenities: (data['amenities'] as Map<String, dynamic>?)?.keys.toList(),
      safetyFeatures:
          (data['safetyFeatures'] as Map<String, dynamic>?)?.keys.toList(),
      specialNotes:
          (data['specialNotes'] as Map<String, dynamic>?)?.keys.toList(),
      meals: (data['meals'] as Map<String, dynamic>?)?.keys.toList(),
    );
  }

  BoatService copyWith({
    bool? isSelected,
    String? serviceName,
    String? description,
    String? rate,
    String? image,
    String? avlbSeats,
    String? details,
    List<String>? amenities,
    List<String>? safetyFeatures,
    List<String>? specialNotes,
    List<String>? meals,
  }) {
    return BoatService(
      id: id,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      image: image ?? this.image,
      avlbSeats: avlbSeats ?? this.avlbSeats,
      isSelected: isSelected ?? this.isSelected,
      details: details ?? this.details,
      amenities: amenities ?? this.amenities,
      safetyFeatures: safetyFeatures ?? this.safetyFeatures,
      specialNotes: specialNotes ?? this.specialNotes,
      meals: meals ?? this.meals,
    );
  }
}

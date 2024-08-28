class AddOnsModel {
  AddOnsModel({
    required this.id,
    required this.name,
    this.currentRate,
    this.isChosen = false,
    this.more,
    this.count = 0,
  });

  AddOnsModel copyWith({
    String? id,
    String? name,
    String? currentRate,
    bool? isChosen,
    String? more,
    int? count,
  }) {
    return AddOnsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      currentRate: currentRate ?? this.currentRate,
      isChosen: isChosen ?? this.isChosen,
      more: more ?? this.more,
      count: count ?? this.count,
    );
  }

  final String id;
  final String name;
  final String? currentRate;
  final bool isChosen;
  final String? more;
  final int count;
}

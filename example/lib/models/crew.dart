class Crew {
  final String name;
  final String agency;
  final String image;
  final String wikipedia;
  final List<String> launches;
  final String status;
  final String id;

  const Crew({
    required this.name,
    required this.agency,
    required this.image,
    required this.wikipedia,
    required this.launches,
    required this.status,
    required this.id,
  });

  factory Crew.fromJson(dynamic json) {
    return Crew(
      name: json['name'],
      agency: json['agency'],
      image: json['image'],
      wikipedia: json['wikipedia'],
      launches: List<String>.from(json['launches']),
      status: json['status'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'agency': agency,
      'image': image,
      'wikipedia': wikipedia,
      'launches': launches,
      'status': status,
      'id': id,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Crew &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          agency == other.agency &&
          image == other.image &&
          wikipedia == other.wikipedia &&
          launches == other.launches &&
          status == other.status &&
          id == other.id;

  @override
  int get hashCode =>
      name.hashCode ^
      agency.hashCode ^
      image.hashCode ^
      wikipedia.hashCode ^
      launches.hashCode ^
      status.hashCode ^
      id.hashCode;

  Crew copyWith({
    String? name,
    String? agency,
    String? image,
    String? wikipedia,
    List<String>? launches,
    String? status,
    String? id,
  }) {
    return Crew(
      name: name ?? this.name,
      agency: agency ?? this.agency,
      image: image ?? this.image,
      wikipedia: wikipedia ?? this.wikipedia,
      launches: launches ?? this.launches,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }
}

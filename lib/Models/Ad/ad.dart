import 'package:json_annotation/json_annotation.dart';
import 'package:pet_sitting/Models/Pet/pet.dart';
import 'package:pet_sitting/Models/User/user_extended.dart';

part 'ad.g.dart';

@JsonSerializable()
class Ad {
  String? id;
  final String title;
  final String? description;
  final int costPerHour;
  final DateTime from;
  final DateTime to;
  final String petId;
  final String creatorId;
  final String location;
  final bool active;

  Ad(
      {this.id,
      required this.location,
      required this.title,
      this.description,
      required this.costPerHour,
      required this.from,
      required this.to,
      required this.creatorId,
      required this.petId,
      required this.active});

  Ad copyWith({
    String? title,
    String? description,
    int? costPerHour,
    DateTime? from,
    DateTime? to,
    String? petId,
    String? creatorId,
    String? location,
    bool? active,
  }) {
    return Ad(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      costPerHour: costPerHour ?? this.costPerHour,
      from: from ?? this.from,
      to: to ?? this.to,
      petId: petId ?? this.petId,
      creatorId: creatorId ?? this.creatorId,
      location: location ?? this.location,
      active: active ?? this.active,
    );
  }

  factory Ad.fromJson(Map<String, dynamic> json) => _$AdFromJson(json);

  Map<String, dynamic> toJson() => _$AdToJson(this);
}

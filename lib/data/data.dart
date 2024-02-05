import 'dart:convert';

import 'package:flutter/foundation.dart';

class Person {
  int id;
  String name;
  String gender;
  String? dateOfBirth;
  String? dateOfDeath;
  int level;
  List<RelationData> relationData;
  double xCoordinate = 0.0;
  double yCoordinates = 0.0;
  double familyWidth = 0.0;
  bool isPatient;
  bool isNodePlaced = false;
  bool isActive=false;
  Person(
      {required this.id,
      required this.name,
      required this.gender,
      this.dateOfBirth,
      this.dateOfDeath,
      required this.level,
      required this.relationData,
      this.isPatient = false,
      this.xCoordinate = 0.0,
      this.yCoordinates = 0.0});

  Person copyWith({
    int? id,
    String? name,
    String? gender,
    String? dateOfBirth,
    String? dateOfDeath,
    int? level,
    List<RelationData>? relationData,
    bool? isPatient,
    double? xCoordinate,
    double? yCoordinates,
  }) {
    return Person(
        id: id ?? this.id,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        dateOfDeath: dateOfDeath ?? this.dateOfDeath,
        level: level ?? this.level,
        relationData: relationData ?? this.relationData,
        isPatient: isPatient ?? this.isPatient,
        xCoordinate: xCoordinate ?? this.xCoordinate,
        yCoordinates: yCoordinates ?? this.yCoordinates);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'dateOfDeath': dateOfDeath,
      'level': level,
      'relationData': relationData.map((x) => x.toMap()).toList(),
      "isPatient": isPatient
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
        id: map['id'],
        name: map['name'],
        gender: map['gender'],
        dateOfBirth: map['dateOfBirth'],
        dateOfDeath: map['dateOfDeath'],
        level: map['level'],
        relationData: List<RelationData>.from(
          (map['relationData']).map<RelationData>(
            (x) => RelationData.fromMap(x),
          ),
        ),
        isPatient: map["isPatient"] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FamilyModel(id: $id, name: $name, gender: $gender, dateOfBirth: $dateOfBirth, dateOfDeath: $dateOfDeath, level: $level, relationData: $relationData)';
  }

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.dateOfBirth == dateOfBirth &&
        other.dateOfDeath == dateOfDeath &&
        other.level == level &&
        listEquals(other.relationData, relationData);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        dateOfBirth.hashCode ^
        dateOfDeath.hashCode ^
        level.hashCode ^
        relationData.hashCode;
  }
}

class RelationData {
  int relatedUserId;
  int relationTypeId;
  RelationData({
    required this.relatedUserId,
    required this.relationTypeId,
  });

  RelationData copyWith({
    int? relatedUserId,
    int? relationTypeId,
  }) {
    return RelationData(
      relatedUserId: relatedUserId ?? this.relatedUserId,
      relationTypeId: relationTypeId ?? this.relationTypeId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'relatedUserId': relatedUserId,
      'relationTypeId': relationTypeId,
    };
  }

  factory RelationData.fromMap(Map<String, dynamic> map) {
    return RelationData(
      relatedUserId: map['relatedUserId'],
      relationTypeId: map['relationTypeId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RelationData.fromJson(String source) =>
      RelationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RelationData(relatedUserId: $relatedUserId, relationTypeId: $relationTypeId)';

  @override
  bool operator ==(covariant RelationData other) {
    if (identical(this, other)) return true;

    return other.relatedUserId == relatedUserId &&
        other.relationTypeId == relationTypeId;
  }

  @override
  int get hashCode => relatedUserId.hashCode ^ relationTypeId.hashCode;
}

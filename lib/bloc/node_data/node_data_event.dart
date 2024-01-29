part of 'node_data_bloc.dart';

abstract class NodeDataEvent {}

final class LoadData extends NodeDataEvent {
  final String name;
  final int? yearOfBirth;
  final int? yearOfDeath;
  final Gender gender;
  LoadData(
      {required this.gender,
      required this.name,
      this.yearOfBirth,
      this.yearOfDeath});
}

final class ChangeData extends NodeDataEvent {
  final String name;
  final int? yearOfBirth;
  final int? yearOfDeath;
  final Gender gender;
  ChangeData(
      {required this.gender,
      required this.name,
      this.yearOfBirth,
      this.yearOfDeath});
}

final class AddData extends NodeDataEvent {
  final String name;
  final int? yearOfBirth;
  final int? yearOfDeath;
  final Gender gender;
  final List<RelationData> relationData;
  AddData({
    required this.gender,
    required this.name,
    this.yearOfBirth,
    this.yearOfDeath,
    this.relationData = const [],
  });
}

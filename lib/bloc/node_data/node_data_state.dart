part of 'node_data_bloc.dart';

sealed class NodeDataState {

}

final class NodeDataLoading extends NodeDataState {}

final class NodeDataLoaded extends NodeDataState {
    final String? name;
  final int? yearOfBirth;
  final int? yearOfDeath;
  final Gender? gender;
  NodeDataLoaded({this.gender, this.name, this.yearOfBirth, this.yearOfDeath});
}

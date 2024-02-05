part of 'node_data_bloc.dart';

sealed class NodeDataState {

}

final class NodeDataLoading extends NodeDataState {}

final class NodeDataLoaded extends NodeDataState {
    final String? name;
  final String? dateOfBirth;
  final String? dateOfDeath;
  final Gender? gender;
  NodeDataLoaded({this.gender, this.name, this.dateOfBirth, this.dateOfDeath});
}

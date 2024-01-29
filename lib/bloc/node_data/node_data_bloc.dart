import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'node_data_event.dart';
part 'node_data_state.dart';

class NodeDataBloc extends Bloc<NodeDataEvent, NodeDataState> {
  NodeDataBloc() : super(NodeDataLoading()) {
    on<LoadData>(
      (event, emit) {
        emit(NodeDataLoading());
        emit(
          NodeDataLoaded(
            gender: event.gender,
            name: event.name,
            yearOfBirth: event.yearOfBirth,
            yearOfDeath: event.yearOfDeath,
          ),
        );
      },
    );
    on<ChangeData>(
      (event, emit) {
        emit(
          NodeDataLoaded(
            gender: event.gender,
            name: event.name,
            yearOfBirth: event.yearOfBirth,
            yearOfDeath: event.yearOfDeath,
          ),
        );
      },
    );
  }
}

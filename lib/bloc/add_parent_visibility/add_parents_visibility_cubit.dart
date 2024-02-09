import 'package:family_tree/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_parents_visibility_state.dart';

class AddParentsVisibilityCubit extends Cubit<AddParentsVisibilityState> {
  AddParentsVisibilityCubit() : super(AddParentsVisibilityState());
  Person? father;
  Person? mother;
  void change({Person? fatherData, Person? motherData, bool value = false}) {
    father = fatherData;
    mother = motherData;
    emit(AddParentsVisibilityState(
        father: father, mother: mother, isAddParentChecked: value));
  }
}

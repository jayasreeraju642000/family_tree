// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_parents_visibility_cubit.dart';

class AddParentsVisibilityState {
  bool isAddParentChecked;
  Person? father;
  Person? mother;
  AddParentsVisibilityState({
    this.isAddParentChecked = false,
    this.father,
    this.mother,
  });
}

part of 'family_tree_bloc.dart';

@immutable
sealed class FamilyTreeEvent {}

final class FamilyTreeLoadingEvent extends FamilyTreeEvent {}

final class UpdateFamilyTreeNodeEvent extends FamilyTreeEvent {
  final FamilyModel node;
  final String? name;
  final String? gender;
  final int? yearOfBirth;
  final int? yearOfDeath;
  UpdateFamilyTreeNodeEvent({
    required this.node,
    this.gender,
    this.name,
    this.yearOfBirth,
    this.yearOfDeath,
  });
}

final class AddFamilyNodeEvent extends FamilyTreeEvent {
  final FamilyModel node;

  AddFamilyNodeEvent({required this.node});
}

final class UpdateOrAddParents extends FamilyTreeEvent {
  final FamilyModel father, mother, child;
  UpdateOrAddParents(
      {required this.child, required this.father, required this.mother});
}

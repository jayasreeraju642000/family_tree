part of 'family_tree_bloc.dart';

@immutable
sealed class FamilyTreeEvent {}

final class FamilyTreeVisibleNodeLoadingEvent extends FamilyTreeEvent {}

final class FamilyTreeAllNodeLoadingEvent extends FamilyTreeEvent {}

final class UpdateFamilyTreeNodeEvent extends FamilyTreeEvent {
  final Person node;
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
  final Person node;
  final bool isFromAddParents;
  AddFamilyNodeEvent({required this.node, required this.isFromAddParents});
}

final class UpdateOrAddParents extends FamilyTreeEvent {
  final Person father, mother, child;
  UpdateOrAddParents({
    required this.child,
    required this.father,
    required this.mother,
  });
}

final class AddSiblings extends FamilyTreeEvent {
  final Person father, mother, sibling;

  AddSiblings({
    required this.father,
    required this.mother,
    required this.sibling,
  });
}

final class AddChildrenEvent extends FamilyTreeEvent {
  final Person partner, node, child;

  AddChildrenEvent({
    required this.partner,
    required this.node,
    required this.child,
  });
}

final class UpdateVisibilityOfRelatedNodes extends FamilyTreeEvent {
  final Person node;
  final bool isExpanded;

  UpdateVisibilityOfRelatedNodes({required this.node,required this.isExpanded});
}

final class AddPartnerNodeEvent extends FamilyTreeEvent {
  final Person node;

  final Person partnerNode;

  AddPartnerNodeEvent( {required this.node,required this.partnerNode,});
}

part of 'family_tree_bloc.dart';

@immutable
sealed class FamilyTreeEvent {}

final class FamilyEventIntitial extends FamilyTreeEvent {
  final double? widthOfNode;
  final double? heightOfNode;
  final bool isChildWidgetVisible;
  FamilyEventIntitial({
    this.widthOfNode,
    this.heightOfNode,
    this.isChildWidgetVisible = false,
  });
}

final class FamilyTreeVisibleNodeLoadingEvent extends FamilyTreeEvent {}

final class FamilyTreeAllNodeLoadingEvent extends FamilyTreeEvent {}

final class UpdateFamilyTreeNodeEvent extends FamilyTreeEvent {
  final Person node;
  final String? name;
  final String? gender;
  final String? dateOfBirth;
  final String? dateOfDeath;
  UpdateFamilyTreeNodeEvent({
    required this.node,
    this.gender,
    this.name,
    this.dateOfBirth,
    this.dateOfDeath,
  });
}

final class DeleteFamilyTreeNode extends FamilyTreeEvent {
  final Person node;

  DeleteFamilyTreeNode({required this.node});
}

final class AddFamilyNodeEvent extends FamilyTreeEvent {
  final Person node;
  final bool isFromAddParents;
  AddFamilyNodeEvent({required this.node, required this.isFromAddParents});
}

final class AddParentEvent extends FamilyTreeEvent {
  final Person father, mother, child;
  AddParentEvent({
    required this.child,
    required this.father,
    required this.mother,
  });
}

final class AddSiblingEvent extends FamilyTreeEvent {
  final Person father, mother, sibling, node;

  AddSiblingEvent(
      {required this.father,
      required this.mother,
      required this.sibling,
      required this.node});
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

  UpdateVisibilityOfRelatedNodes(
      {required this.node, required this.isExpanded});
}

final class AddPartnerNodeEvent extends FamilyTreeEvent {
  final Person node;

  final Person partnerNode;

  AddPartnerNodeEvent({
    required this.node,
    required this.partnerNode,
  });
}

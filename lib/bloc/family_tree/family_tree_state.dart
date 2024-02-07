part of 'family_tree_bloc.dart';

@immutable
sealed class FamilyTreeState {
  final double horizontalGap = 75;
}

final class FamilyTreeLoading extends FamilyTreeState {
  
}

final class FamilyTreeVisibleNodesLoaded extends FamilyTreeState {
  final List<Person> nodes;
  final double widthOfNode;
  final double heightOfNode;

  final double viewPortWidth;
  final double viewPortHeight;
  final double verticalGap;
  FamilyTreeVisibleNodesLoaded(
      {required this.nodes,
      required this.heightOfNode,
      required this.widthOfNode,
      required this.viewPortHeight,
      required this.viewPortWidth,
      required this.verticalGap});
}

final class FamilyTreeAllNodesLoaded extends FamilyTreeState {
  final List<Person> nodes;

  final double widthOfNode;
  final double heightOfNode;
  final double verticalGap;

  FamilyTreeAllNodesLoaded(
      {required this.nodes,
      required this.widthOfNode,
      required this.heightOfNode,
      required this.verticalGap});
}

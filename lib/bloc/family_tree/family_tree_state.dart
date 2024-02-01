part of 'family_tree_bloc.dart';

@immutable
sealed class FamilyTreeState {
  
  final double widthOfNode = 150;
  final double heightOfNode = 40;
  final double horizontalGap = 75;
  final double verticalGap = 80;
}

final class FamilyTreeLoading extends FamilyTreeState {
  
}

final class FamilyTreeVisibleNodesLoaded extends FamilyTreeState {
  final List<Person> nodes;

  final double viewPortWidth;
  final double viewPortHeight;

  FamilyTreeVisibleNodesLoaded(
      {required this.nodes,
      required this.viewPortHeight,
      required this.viewPortWidth});
}


final class FamilyTreeAllNodesLoaded extends FamilyTreeState {
  final List<Person> nodes;


  FamilyTreeAllNodesLoaded(
      {required this.nodes,});
}

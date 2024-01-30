import 'dart:math';

import 'package:family_tree/data/data.dart';
import 'package:family_tree/data/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'family_tree_event.dart';
part 'family_tree_state.dart';

class FamilyTreeBloc extends Bloc<FamilyTreeEvent, FamilyTreeState> {
  static List<Person> nodes = [];

  List<Person> sampleData =
      sample.map((e) => Person.fromMap(e)).toList();
  List<Person> visitedNodes = [];
  Map<int, double> lastLevelWiseXcordinate = {};
  int largestLevel = 0;
  int lowestLevel = 0;
  double viewPortWidth = 0.0;
  double viewPortHeight = 0.0;

  FamilyTreeBloc() : super(FamilyTreeLoading()) {
    on<FamilyTreeLoadingEvent>((event, emit) {
      emit(FamilyTreeLoading());
      if (nodes.isEmpty) {
        nodes = sampleData;
      }
      loadFamilyTree(emit);
    });
    on<UpdateFamilyTreeNodeEvent>((event, emit) {
      emit(FamilyTreeLoading());
      event.node.name = event.name ?? event.node.name;
      event.node.yearOfBirth = event.yearOfBirth;
      event.node.yearOfDeath = event.yearOfDeath;
      event.node.gender = event.gender ?? event.node.gender;
      emit(
        FamilyTreeLoaded(
          nodes: nodes,
          viewPortHeight: viewPortHeight,
          viewPortWidth: viewPortWidth,
        ),
      );
    });
    on<AddFamilyNodeEvent>((event, emit) {
      emit(FamilyTreeLoading());
      if (!nodes.contains(event.node)) {
        nodes.add(event.node);
      }
      loadFamilyTree(emit);
    });
    on<UpdateOrAddParents>((event, emit) {
      emit(FamilyTreeLoading());
      event.father.relationData.addAll([
        RelationData(relatedUserId: event.mother.id, relationTypeId: 0),
      ]);
      event.mother.relationData.addAll([
        RelationData(relatedUserId: event.father.id, relationTypeId: 0),
      ]);
      event.child.relationData
          .removeWhere((element) => element.relationTypeId == 1);
      event.child.relationData.addAll([
        RelationData(relatedUserId: event.mother.id, relationTypeId: 1),
        RelationData(relatedUserId: event.father.id, relationTypeId: 1),
      ]);
      lowestLevel = event.father.level;
      loadFamilyTree(emit);
    });

    on<AddSiblings>((event, emit) {
      event.father.relationData.add(
          RelationData(relatedUserId: event.sibling.id, relationTypeId: 2));
      event.mother.relationData.add(
          RelationData(relatedUserId: event.sibling.id, relationTypeId: 2));
      nodes.add(event.sibling);
      loadFamilyTree(emit);
    });
  }

  void loadFamilyTree(emit) {
    lowestLevel = nodes.map((node) => node.level).reduce(min);
    largestLevel = nodes.map((node) => node.level).reduce(max);
    placeNodes();

    for (var element in nodes) {
      if (element.xCoordinate > viewPortWidth) {
        viewPortWidth = element.xCoordinate +
            2 * state.horizontalGap +
            2 * state.widthOfNode;
      }
    }
    viewPortHeight = (largestLevel - lowestLevel) *
        (state.verticalGap + state.heightOfNode / 2);

    emit(FamilyTreeLoaded(
        nodes: nodes,
        viewPortHeight: viewPortHeight,
        viewPortWidth: viewPortWidth));

    // for (int i = lowestLevel; i <= largestLevel; i++) {
    //   debugPrint("********************   $i   ******************");

    //   var nodesInThisLevel =
    //       nodes.where((element) => element.level == i).toList();
    //   nodesInThisLevel.sort(
    //     (a, b) => a.xCoordinate.compareTo(b.xCoordinate),
    //   );
    //   debugPrint("${nodesInThisLevel.map((e) => (
    //         e.level,
    //         e.xCoordinate,
    //         e.yCoordinates,
    //       )).toList()}");
    //   debugPrint("********************  / $i   ****************** \n");
    // }
  }

  void placeNodes() {
    var nodesInTheSameLevel =
        nodes.where((element) => element.level == lowestLevel).toList();
    lastLevelWiseXcordinate.clear();
    visitedNodes.clear();
    for (int i = 0; i < nodesInTheSameLevel.length; i++) {
      if (visitedNodes.contains(nodesInTheSameLevel[i])) {
        continue;
      }
      visitedNodes.add(nodesInTheSameLevel[i]);
      lastLevelWiseXcordinate[lowestLevel] =
          (lastLevelWiseXcordinate[lowestLevel] ?? 0) +
              state.widthOfNode +
              state.horizontalGap;

      getpartnerAndChild(nodesInTheSameLevel[i],
          lastLevelWiseXcordinate[lowestLevel + 1] ?? 0, 0);
    }
  }

  void getpartnerAndChild(
      Person node, double xCoordinate, double yCoordinates) {
    var partnerNodeIds = node.relationData
        .where((element) => element.relationTypeId == 0)
        .toList();
    if ((lastLevelWiseXcordinate[node.level + 1] ?? 0) < xCoordinate) {
      node.xCoordinate = xCoordinate;
    } else {
      node.xCoordinate = lastLevelWiseXcordinate[node.level + 1] ?? 0;
    }

    node.yCoordinates = yCoordinates;
    if ((lastLevelWiseXcordinate[node.level] ?? 0) <
        node.xCoordinate + state.widthOfNode + state.horizontalGap) {
      lastLevelWiseXcordinate[node.level] =
          node.xCoordinate + state.widthOfNode + state.horizontalGap;
      lastLevelWiseXcordinate[node.level - 1] =
          node.xCoordinate + state.widthOfNode + state.horizontalGap;
    }
    if (partnerNodeIds.isNotEmpty) {
      for (var partner in partnerNodeIds) {
        var partnerNode =
            nodes.firstWhere((element) => element.id == partner.relatedUserId);
        if (visitedNodes.contains(partnerNode)) {
          continue;
        }

        visitedNodes.add(partnerNode);
        partnerNode.yCoordinates = yCoordinates;

        partnerNode.xCoordinate =
            node.xCoordinate + state.widthOfNode + state.horizontalGap;

        lastLevelWiseXcordinate[node.level] =
            partnerNode.xCoordinate + state.widthOfNode + state.horizontalGap;
        lastLevelWiseXcordinate[node.level - 1] =
            partnerNode.xCoordinate + state.widthOfNode + state.horizontalGap;

        var childrenIdsOfNode = node.relationData
            .where((element) => element.relationTypeId == 2)
            .map((e) => e.relatedUserId)
            .toList();
        var childrenIdsOfPartner = partnerNode.relationData
            .where((element) => element.relationTypeId == 2)
            .map((e) => e.relatedUserId)
            .toList();
        var commonChildren = childrenIdsOfNode
            .where((element) => childrenIdsOfPartner.contains(element))
            .toList();

        for (int i = 0; i < commonChildren.length; i++) {
          var startingXCoordinate = 0.0;
          if ((lastLevelWiseXcordinate[node.level + 1] ?? 0) <
              node.xCoordinate) {
            startingXCoordinate = node.xCoordinate;
          } else {
            startingXCoordinate = lastLevelWiseXcordinate[node.level + 1] ?? 0;
          }

          var child =
              nodes.firstWhere((element) => element.id == commonChildren[i]);

          // if (commonChildren.length == 1) {
          // getpartnerAndChild(
          //     child,
          //     startingXCoordinate + widthOfNode / 2 + horizontalGap / 2,
          //     yCoordinates + verticalGap);
          // } else {
          getpartnerAndChild(
              child, startingXCoordinate, yCoordinates + state.verticalGap);
          // }
        }
      }
    }
  }
}

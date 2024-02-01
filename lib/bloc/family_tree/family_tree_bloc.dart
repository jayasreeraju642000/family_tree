import 'dart:math';

import 'package:family_tree/data/data.dart';
import 'package:family_tree/data/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'family_tree_event.dart';
part 'family_tree_state.dart';

class FamilyTreeBloc extends Bloc<FamilyTreeEvent, FamilyTreeState> {
  static List<Person> nodes = [];
  static List<Person> activeNodes = [];
  static Map<int, bool> nodeFamiliesExpandedId = {};
  List<int> directRelativesOfPatient = [];
  List<Person> sampleData =
      sample.map((sampleData) => Person.fromMap(sampleData)).toList();
  List<Person> visitedNodes = [];
  Map<int, double> lastLevelWiseXcordinate = {};
  int largestLevel = 0;
  int lowestLevel = 0;
  double viewPortWidth = 0.0;
  double viewPortHeight = 0.0;

  FamilyTreeBloc() : super(FamilyTreeLoading()) {
    on<FamilyTreeVisibleNodeLoadingEvent>((event, emit) {
      emit(FamilyTreeLoading());
      if (nodes.isEmpty) {
        nodes = sampleData;
      }
      loadFamilyTree(emit);
    });

    on<FamilyTreeAllNodeLoadingEvent>((event, emit) {
      emit(FamilyTreeLoading());
      emit(FamilyTreeAllNodesLoaded(nodes: nodes));
    });

    on<UpdateFamilyTreeNodeEvent>((event, emit) {
      emit(FamilyTreeLoading());
      event.node.name = event.name ?? event.node.name;
      event.node.yearOfBirth = event.yearOfBirth;
      event.node.yearOfDeath = event.yearOfDeath;
      event.node.gender = event.gender ?? event.node.gender;
      emit(
        FamilyTreeVisibleNodesLoaded(
          nodes: nodes,
          viewPortHeight: viewPortHeight,
          viewPortWidth: viewPortWidth,
        ),
      );
    });

    on<AddFamilyNodeEvent>((event, emit) {
      emit(FamilyTreeLoading());
      if (!nodes.contains(event.node)) {
        event.node.isNodePlaced = true;
        nodes.add(event.node);
      }
      if (!event.isFromAddParents) {
        loadFamilyTree(emit);
      } else {
        emit(FamilyTreeAllNodesLoaded(nodes: nodes));
      }
    });

    on<UpdateOrAddParents>((event, emit) {
      emit(FamilyTreeLoading());
      if (!event.father.relationData
          .any((element) => element.relatedUserId == event.mother.id)) {
        event.father.relationData.add(
          RelationData(relatedUserId: event.mother.id, relationTypeId: 0),
        );
      }
      if (!event.father.relationData
          .any((element) => element.relatedUserId == event.child.id)) {
        event.father.relationData.add(
          RelationData(relatedUserId: event.child.id, relationTypeId: 2),
        );
      }

      if (!event.mother.relationData
          .any((element) => element.relatedUserId == event.father.id)) {
        event.mother.relationData.add(
          RelationData(relatedUserId: event.father.id, relationTypeId: 0),
        );
      }
      if (!event.mother.relationData
          .any((element) => element.relatedUserId == event.child.id)) {
        event.father.relationData.add(
          RelationData(relatedUserId: event.child.id, relationTypeId: 2),
        );
      }
      event.child.relationData
          .removeWhere((element) => element.relationTypeId == 1);
      event.child.relationData.addAll([
        RelationData(relatedUserId: event.mother.id, relationTypeId: 1),
        RelationData(relatedUserId: event.father.id, relationTypeId: 1),
      ]);

      loadFamilyTree(emit);
    });

    on<AddSiblings>((event, emit) {
      event.father.relationData.add(
          RelationData(relatedUserId: nodes.length + 1, relationTypeId: 2));
      event.mother.relationData.add(
          RelationData(relatedUserId: nodes.length + 1, relationTypeId: 2));
      nodes.add(event.sibling.copyWith(id: nodes.length + 1));
      loadFamilyTree(emit);
    });

    on<UpdateVisibilityOfRelatedNodes>((event, emit) {
      emit(FamilyTreeLoading());
      if (!nodeFamiliesExpandedId.containsKey(event.node.id)) {
        nodeFamiliesExpandedId[event.node.id] = true;
      } else {
        nodeFamiliesExpandedId[event.node.id] =
            !nodeFamiliesExpandedId[event.node.id]!;
      }
      if (!event.isExpanded) {
        var node = nodes.firstWhere((element) => element.id == event.node.id);
        var relations = node.relationData
            .map((r) => r.relatedUserId)
            .toList()
            .map((i) => nodes.firstWhere((node) => node.id == i))
            .toList();
        for (var relation in relations) {
          relation.isActive = true;
        }
      } else {
        if (directRelativesOfPatient.contains(event.node.id)) {
          var parents = event.node.relationData
              .where((element) => element.relationTypeId == 1)
              .toList()
              .map((id) => id.relatedUserId)
              .toList()
              .map((child) => nodes.firstWhere((node) => node.id == child))
              .toList()
              .first;
          var children = parents.relationData
              .where((element) => element.relationTypeId == 2)
              .toList()
              .map((id) => id.relatedUserId)
              .toList()
              .map((child) => nodes.firstWhere((node) => node.id == child))
              .toList();
          exansionHidingForChildren(children);
        } else {
          var children = event.node.relationData
              .where((element) => element.relationTypeId == 2)
              .toList()
              .map((id) => id.relatedUserId)
              .toList()
              .map((child) => nodes.firstWhere((node) => node.id == child))
              .toList();
          exansionHidingForChildren(children);
        }
        nodes.where((element) => element.isActive).toList().forEach((element) {
          element.isActive = false;
        });
      }
      var outputKeys = nodeFamiliesExpandedId.keys
          .where((key) => nodeFamiliesExpandedId[key] == true)
          .toList();
      outputKeys
          .map((key) => nodes.firstWhere((element) => element.id == key))
          .toList()
          .forEach((element) {
        element.relationData
            .map((i) => i.relatedUserId)
            .toList()
            .map((item) => nodes.firstWhere((node) => node.id == item))
            .toList()
            .forEach((relation) {
          relation.isActive = true;
        });
      });
      loadFamilyTree(emit);
    });

    on<AddPartnerNodeEvent>((event, emit) {
      var partner = event.partnerNode.copyWith(id: nodes.length + 1);
      nodes.add(partner);
      event.node.relationData
          .add(RelationData(relatedUserId: partner.id, relationTypeId: 0));
    });
  }

  void exansionHidingForChildren(List<Person> children) {
    for (var child in children) {
      if (nodeFamiliesExpandedId.containsKey(child.id)) {
        nodeFamiliesExpandedId[child.id] = false;
        var childrensOfChild = child.relationData
            .where((element) => element.relationTypeId == 2)
            .toList()
            .map((id) => id.relatedUserId)
            .toList()
            .map((child) => nodes.firstWhere((node) => node.id == child))
            .toList();
        exansionHidingForChildren(childrensOfChild);
      }
    }
  }

  void loadFamilyTree(emit) {
    lowestLevel = nodes.map((node) => node.level).reduce(min);
    largestLevel = nodes.map((node) => node.level).reduce(max);
    for (var e in nodes) {
      e.isNodePlaced = false;
    }

    visibilitySetUp();
    activeNodes = nodes.where((element) => element.isActive).toList();
    placeNodes();
    correctThePositionOfNotVisitedNodes();

    activeNodes.sort(
      (a, b) => a.level.compareTo(b.level),
    );

    for (var element in activeNodes) {
      if (element.xCoordinate >= viewPortWidth) {
        viewPortWidth = element.xCoordinate +
            2 * state.horizontalGap +
            2 * state.widthOfNode;
      }
      if (element.yCoordinates >= viewPortHeight) {
        viewPortHeight = element.yCoordinates +
            2 * state.verticalGap +
            2 * state.heightOfNode;
      }
    }

    emit(FamilyTreeVisibleNodesLoaded(
        nodes: activeNodes,
        viewPortHeight: viewPortHeight,
        viewPortWidth: viewPortWidth));
  }

  void placeNodes() {
    var visitedNodeLowestLevel =
        activeNodes.map((node) => node.level).reduce(min);
    var nodesInTheSameLevel = activeNodes
        .where((element) => element.level == visitedNodeLowestLevel)
        .toList();
    lastLevelWiseXcordinate.clear();
    visitedNodes.clear();
    visitedNodes.add(nodesInTheSameLevel.first);
    lastLevelWiseXcordinate[lowestLevel] =
        (lastLevelWiseXcordinate[lowestLevel] ?? 0) +
            state.widthOfNode +
            state.horizontalGap;

    getpartnerAndChild(nodesInTheSameLevel.first,
        lastLevelWiseXcordinate[lowestLevel + 1] ?? 0, 0);
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
    node.isNodePlaced = true;
    if ((lastLevelWiseXcordinate[node.level] ?? 0) <
        node.xCoordinate + state.widthOfNode + state.horizontalGap) {
      lastLevelWiseXcordinate[node.level] =
          node.xCoordinate + state.widthOfNode + state.horizontalGap;
      lastLevelWiseXcordinate[node.level - 1] =
          node.xCoordinate + state.widthOfNode + state.horizontalGap;
    }
    if (partnerNodeIds.isNotEmpty) {
      for (var partner in partnerNodeIds) {
        if (activeNodes
                .indexWhere((element) => element.id == partner.relatedUserId) !=
            -1) {
          var partnerNode = activeNodes
              .firstWhere((element) => element.id == partner.relatedUserId);
          partnerNode.isActive = true;
          if (visitedNodes.contains(partnerNode)) {
            continue;
          }

          partnerNode.yCoordinates = yCoordinates;

          partnerNode.xCoordinate =
              node.xCoordinate + state.widthOfNode + state.horizontalGap;
          partnerNode.isNodePlaced = true;
          lastLevelWiseXcordinate[node.level] =
              partnerNode.xCoordinate + state.widthOfNode + state.horizontalGap;
          lastLevelWiseXcordinate[node.level - 1] =
              partnerNode.xCoordinate + state.widthOfNode + state.horizontalGap;

          var childrenIdsOfNode = node.relationData
              .where((element) => element.relationTypeId == 2)
              .map((child) => child.relatedUserId)
              .toList();
          var childrenIdsOfPartner = partnerNode.relationData
              .where((element) => element.relationTypeId == 2)
              .map((childP) => childP.relatedUserId)
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
              startingXCoordinate =
                  lastLevelWiseXcordinate[node.level + 1] ?? 0;
            }

            var child =
                nodes.firstWhere((element) => element.id == commonChildren[i]);
            child.isActive = true;
            if (!activeNodes.contains(child)) {
              activeNodes.add(child);
            }
            if (commonChildren.length == 1) {
              lastLevelWiseXcordinate[node.level + 1] =
                  partnerNode.xCoordinate +
                      state.widthOfNode +
                      state.horizontalGap;
            }
            if (!child.isNodePlaced) {
              getpartnerAndChild(
                  child, startingXCoordinate, yCoordinates + state.verticalGap);
            } // }
          }
        }
      }
    }
  }

  void correctThePositionOfNotVisitedNodes() {
    for (int i = lowestLevel; i < largestLevel + 1; i++) {
      var notVisitedNodes = nodes
          .where((element) => element.level == i && !element.isNodePlaced)
          .toList();
      for (int j = 0; j < notVisitedNodes.length; j++) {
        if (visitedNodes.contains(notVisitedNodes[j])) {
          continue;
        }
        if (notVisitedNodes[j]
            .relationData
            .any((element) => element.relationTypeId == 2)) {
          var childrenIds = notVisitedNodes[j]
              .relationData
              .where((element) => element.relationTypeId == 2)
              .toList()
              .map((data) => data.relatedUserId)
              .toList();

          var children = childrenIds
              .map((item) => nodes.firstWhere((element) => element.id == item))
              .toList()
              .where((element) => element.isNodePlaced)
              .toList();
          if (children.isNotEmpty) {
            double leftMostChildXcoordinate = children.first.xCoordinate;
            double yCoordinates =
                children.first.yCoordinates - state.verticalGap;
            for (int k = 1; k < children.length; k++) {
              if (leftMostChildXcoordinate > children[k].xCoordinate) {
                leftMostChildXcoordinate = children[k].xCoordinate;
              }
            }
            notVisitedNodes[j].xCoordinate = leftMostChildXcoordinate;
            notVisitedNodes[j].yCoordinates = yCoordinates;
            var partnerNodeIds = notVisitedNodes[j]
                .relationData
                .where((element) => element.relationTypeId == 0)
                .toList();
            if (partnerNodeIds.isNotEmpty) {
              for (var partner in partnerNodeIds) {
                var partnerNode = nodes.firstWhere(
                    (element) => element.id == partner.relatedUserId);
                if (visitedNodes.contains(partnerNode)) {
                  continue;
                }

                visitedNodes.add(partnerNode);
                partnerNode.yCoordinates = yCoordinates;

                partnerNode.xCoordinate = notVisitedNodes[j].xCoordinate +
                    state.widthOfNode +
                    state.horizontalGap;
                partnerNode.isNodePlaced = true;
              }
            }
          }
        }
      }
    }
  }

  void visibilitySetUp() {
    directRelativesOfPatient.clear();
    var patient = nodes.firstWhere((element) => element.isPatient);
    patient.isActive = true;
directRelativesOfPatient.add(patient.id);
    var relationIds =
        patient.relationData.map((relation) => relation.relatedUserId).toList();
    var relationNodes = relationIds
        .map((relationId) =>
            nodes.firstWhere((element) => element.id == relationId))
        .toList();
    for (var element in relationNodes) {
      element.isActive = true;
directRelativesOfPatient.add(element.id);

    }
  }
}

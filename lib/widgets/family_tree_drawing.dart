import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:family_tree/data/data.dart';

class FamilyTreeDrawing extends StatefulWidget {
  final List<Person> nodes;
  final double width;
  final double height;
  final double nodeWidth;
  final double nodeHeight;
  final double verticalGap;
  final double horizontalGap;

  const FamilyTreeDrawing(
      {super.key,
      required this.nodes,
      required this.width,
      required this.height,
      required this.nodeWidth,
      required this.nodeHeight,
      required this.verticalGap,
      required this.horizontalGap});

  @override
  State<FamilyTreeDrawing> createState() => _FamilyTreeDrawingState();
}

class _FamilyTreeDrawingState extends State<FamilyTreeDrawing> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      foregroundPainter: FamilyTreePainter(
          nodes: widget.nodes,
          horizontalGap: widget.horizontalGap,
          verticalGap: widget.verticalGap,
          nodeHeight: widget.nodeHeight,
          nodeWidth: widget.nodeWidth),
    );
  }
}

class FamilyTreePainter extends CustomPainter {
  final List<Person> nodes;
  final double horizontalGap;
  final double verticalGap;
  final double nodeHeight;
  final double nodeWidth;
  FamilyTreePainter({
    required this.nodes,
    required this.horizontalGap,
    required this.verticalGap,
    required this.nodeHeight,
    required this.nodeWidth,
  });
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var node in nodes) {
      if (node.relationData.any((element) => element.relationTypeId == 0)) {
        if (nodes.indexWhere((element) =>
                element.id ==
                node.relationData
                    .firstWhere((item) => item.relationTypeId == 0)
                    .relatedUserId) !=
            -1) {
          double partnersXCoordinate = nodes
              .firstWhere((element) =>
                  element.id ==
                  node.relationData
                      .where((e) => e.relationTypeId == 0)
                      .first
                      .relatedUserId)
              .xCoordinate;
          var firstXCoordinate = (((node.xCoordinate) > partnersXCoordinate)
                  ? partnersXCoordinate
                  : (node.xCoordinate)) +
              nodeWidth;
          var secondXCoordinate = ((node.xCoordinate) < partnersXCoordinate)
              ? partnersXCoordinate
              : (node.xCoordinate);
          canvas.drawLine(
              Offset(firstXCoordinate, (node.yCoordinates) + nodeHeight / 2),
              Offset(secondXCoordinate, (node.yCoordinates) + nodeHeight / 2),
              Paint()
                ..color = Colors.grey
                ..strokeWidth = 1);

          if (node.relationData.map((e) => e.relationTypeId).contains(2)) {
            canvas.drawLine(
                Offset(((firstXCoordinate + secondXCoordinate) / 2),
                    (node.yCoordinates) + nodeHeight / 2),
                Offset(((firstXCoordinate + secondXCoordinate) / 2),
                    ((node.yCoordinates) + verticalGap) - nodeHeight / 2),
                Paint()
                  ..color = Colors.grey
                  ..strokeWidth = 1);
          }
        }
      }

      if (!node.relationData.any((element) => element.relationTypeId == 0)) {
        if (node.relationData.any((element) => element.relationTypeId == 2)) {
          canvas.drawLine(
              Offset(((node.xCoordinate)) + horizontalGap,
                  (node.yCoordinates) + nodeHeight / 2),
              Offset(((node.xCoordinate)) + horizontalGap,
                  ((node.yCoordinates) + verticalGap) - nodeHeight / 2),
              Paint()
                ..color = Colors.grey
                ..strokeWidth = 1);
        }
      }

      if (node.relationData.any((element) => element.relationTypeId == 1)) {
        var parentIds = node.relationData
            .where((element) => element.relationTypeId == 1)
            .toList();
        bool isParentVisible = false;
        for (var parentId in parentIds) {
          if (nodes
              .map((item) => item.id)
              .toList()
              .contains(parentId.relatedUserId)) {
            isParentVisible = true;
          }
        }
        if (isParentVisible) {
          canvas.drawLine(
            Offset((node.xCoordinate) + nodeWidth / 2,
                (node.yCoordinates) - verticalGap / 4),
            Offset((node.xCoordinate) + nodeWidth / 2,
                (node.yCoordinates) + verticalGap / 6),
            Paint()
              ..color = Colors.grey
              ..strokeWidth = 1,
          );
        }
      }
      List<Person> nodesWithSameParents = [];

      nodes
          .where((element) => element.level == node.level)
          .toList()
          .forEach((element) {
        List<int> currentNodeParent = node.relationData
            .where((f) => f.relationTypeId == 1)
            .toList()
            .map((e) => e.relatedUserId)
            .toList();
        List<int> elementParents = element.relationData
            .where((e) => e.relationTypeId == 1)
            .toList()
            .map((e) => e.relatedUserId)
            .toList();
        if (!identical(element, node)) {
          if (listEquals(currentNodeParent, elementParents)) {
            nodesWithSameParents.add(element);
          }
        }
      });

      double leftMostNodeCenterXCordinate = node.xCoordinate;
      double rightMostNodeCenterXCordinate = node.xCoordinate;
      if (node.relationData.any(
        (element) => element.relationTypeId == 0,
      )) {
        var partnerList = node.relationData
            .where(
              (element) => element.relationTypeId == 0,
            )
            .toList();

        for (var partner in partnerList) {
          var childrenIdsOfNode = node.relationData
              .where((element) => element.relationTypeId == 2)
              .map((e) => e.relatedUserId)
              .toList();
          if (nodes.indexWhere(
                  (element) => element.id == partner.relatedUserId) !=
              -1) {
            var partnerNode = nodes
                .firstWhere((element) => element.id == partner.relatedUserId);

            var childrenIdsOfPartner = partnerNode.relationData
                .where((element) => element.relationTypeId == 2)
                .map((e) => e.relatedUserId)
                .toList();
            var commonChildren = childrenIdsOfNode
                .where((element) => childrenIdsOfPartner.contains(element))
                .toList();
            List<Person> childrenNodes = [];
            for (var child in commonChildren) {
              if (nodes.indexWhere((element) => element.id == child) != -1) {
                childrenNodes
                    .add(nodes.firstWhere((element) => element.id == child));
              }
            }
            if (childrenNodes.isNotEmpty) {
              if (commonChildren.length > 1) {
                childrenNodes.sort(
                  (a, b) => a.xCoordinate.compareTo(b.xCoordinate),
                );
                leftMostNodeCenterXCordinate =
                    childrenNodes.first.xCoordinate + (nodeWidth) / 2;
                rightMostNodeCenterXCordinate =
                    childrenNodes.last.xCoordinate - (nodeWidth) / 2;

                if (leftMostNodeCenterXCordinate !=
                    rightMostNodeCenterXCordinate) {
                  canvas.drawLine(
                      Offset(leftMostNodeCenterXCordinate,
                          (node.yCoordinates + verticalGap / 4 + nodeHeight)),
                      Offset(
                          rightMostNodeCenterXCordinate +
                              (nodeWidth / 2 + horizontalGap),
                          (node.yCoordinates + verticalGap / 4 + nodeHeight)),
                      Paint()
                        ..color = Colors.grey
                        ..strokeWidth = 1);
                }
              } else {
                canvas.drawLine(
                    Offset(
                        (node.xCoordinate < partnerNode.xCoordinate
                                ? node.xCoordinate
                                : partnerNode.xCoordinate) +
                            nodeWidth / 2,
                        (node.yCoordinates + verticalGap / 4 + nodeHeight)),
                    Offset(
                        (node.xCoordinate < partnerNode.xCoordinate
                                ? node.xCoordinate
                                : partnerNode.xCoordinate) +
                            nodeWidth +
                            horizontalGap / 2,
                        (node.yCoordinates + verticalGap / 4 + nodeHeight)),
                    Paint()
                      ..color = Colors.grey
                      ..strokeWidth = 1);
              }
            }
          }
        }
      }
    }
  }
}

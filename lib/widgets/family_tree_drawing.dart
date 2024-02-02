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

  List<String> visitedPairs = [];

  @override
  void paint(Canvas canvas, Size size) {
    visitedPairs.clear();
    for (var node in nodes) {
      // draw line to partner
      partnerDrawing(node, canvas);
      childVerticlLineDrawing(node, canvas);
    }
  }

  void partnerDrawing(Person node, Canvas canvas) {
    var partnerId = node.relationData
        .where((element) => element.relationTypeId == 0)
        .toList()
        .map((p) => p.relatedUserId)
        .toList();
    for (var partner in partnerId) {
      if (nodes.map((item) => item.id).toList().contains(partner)) {
        var partnerNode = nodes.firstWhere((element) => element.id == partner);
        double firstXCoordinate = node.xCoordinate;
        double secondXCoordinate = partnerNode.xCoordinate;
        var partnerList = [node.id, partnerNode.id];
        partnerList.sort(
          (a, b) => a.compareTo(b),
        );
        if (visitedPairs.contains(partnerList.toString())) {
          continue;
        } else {
          visitedPairs.add(partnerList.toString());
        }

        double xCoordinate = firstXCoordinate < secondXCoordinate
            ? firstXCoordinate
            : secondXCoordinate;
        canvas.drawLine(
            Offset(xCoordinate + nodeWidth, node.yCoordinates + nodeHeight / 2),
            Offset(xCoordinate + nodeWidth + horizontalGap,
                partnerNode.yCoordinates + nodeHeight / 2),
            Paint()
              ..color = Colors.grey
              ..strokeWidth = 1);
        // check for the common children is visible and draw line from center

        checkForAnyChildIsVisible(node, partnerNode, canvas);
      }
    }
  }

  void checkForAnyChildIsVisible(
      Person node, Person partnerNode, Canvas canvas) {
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
    bool anyChildVisible = false;
    for (var child in commonChildren) {
      if (nodes.map((item) => item.id).toList().contains(child)) {
        anyChildVisible = true;
        break;
      }
    }
    if (anyChildVisible) {
      double firstXCoordinate = node.xCoordinate;
      double secondXCoordinate = partnerNode.xCoordinate;
      double xCoordinate = (firstXCoordinate < secondXCoordinate
              ? firstXCoordinate
              : secondXCoordinate) +
          nodeWidth +
          horizontalGap / 2;
      canvas.drawLine(
        Offset(xCoordinate, node.yCoordinates + nodeHeight / 2),
        Offset(xCoordinate,
            partnerNode.yCoordinates + nodeHeight / 2 + verticalGap / 2),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1,
      );
    }

    if (commonChildren.isNotEmpty)
// if only have one child
    {
      if (commonChildren.length == 1) {
        drawHorizontalLineToSingleChild(
          commonChildren,
          node,
          partnerNode,
          canvas,
        );
      } else {
        multiChildConnectorDrawing(
          commonChildren,
          canvas,
          node,
          partnerNode,
        );
      }
    }
  }

  void multiChildConnectorDrawing(List<int> commonChildren, Canvas canvas,
      Person node, Person partnerNode) {
    List<Person> children = [];
    for (var child in commonChildren) {
      if (nodes.map((item) => item.id).toList().contains(child)) {
        children.add(nodes.firstWhere((element) => element.id == child));
      }
    }

    double leftMostChildXcoordinate = children.first.xCoordinate;
    double rightMostChildXcoordinate = children.first.xCoordinate;

    for (var child in children) {
      if (leftMostChildXcoordinate > child.xCoordinate) {
        leftMostChildXcoordinate = child.xCoordinate;
      }

      if (rightMostChildXcoordinate < child.xCoordinate) {
        rightMostChildXcoordinate = child.xCoordinate;
      }
    }
    canvas.drawLine(
      Offset(leftMostChildXcoordinate + nodeWidth / 2,
          node.yCoordinates + nodeHeight / 2 + verticalGap / 2),
      Offset(rightMostChildXcoordinate + nodeWidth / 2,
          partnerNode.yCoordinates + nodeHeight / 2 + verticalGap / 2),
      Paint()
        ..color = Colors.grey
        ..strokeWidth = 1,
    );
  }

  void drawHorizontalLineToSingleChild(List<int> commonChildren, Person node,
      Person partnerNode, Canvas canvas) {
    var child =
        nodes.firstWhere((element) => element.id == commonChildren.first);
    double firstXCoordinate = node.xCoordinate;
    double secondXCoordinate = partnerNode.xCoordinate;
    double xCoordinate = (firstXCoordinate < secondXCoordinate
            ? firstXCoordinate
            : secondXCoordinate) +
        nodeWidth +
        horizontalGap / 2;

    double childXcoordinate = child.xCoordinate + nodeWidth / 2;
    canvas.drawLine(
      Offset(xCoordinate, node.yCoordinates + nodeHeight / 2 + verticalGap / 2),
      Offset(childXcoordinate,
          partnerNode.yCoordinates + nodeHeight / 2 + verticalGap / 2),
      Paint()
        ..color = Colors.grey
        ..strokeWidth = 1,
    );
  }

  void childVerticlLineDrawing(Person node, Canvas canvas) {
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
        } else {
          isParentVisible = false;
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
  }
}

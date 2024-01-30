import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/add_relation.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:family_tree/family_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';

class FamilyNodeWidget extends StatelessWidget {
  final Person node;
  final double widthOfNode;
  final double heightOfNode;
  final Function? function;
  const FamilyNodeWidget(
      {Key? key,
      required this.node,
      required this.heightOfNode,
      required this.widthOfNode,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: node.yCoordinates,
      left: node.xCoordinate,
      child: Container(
        alignment: Alignment.bottomCenter,
        width: widthOfNode,
        height: heightOfNode,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${node.yearOfBirth ?? 'NA'} - ${node.yearOfDeath ?? 'NA'}',
                  style: const TextStyle(fontSize: 9),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (ctx) => AddRelation(
                        node: node,
                      ),
                    ).then((value) {
                      context
                          .read<FamilyTreeBloc>()
                          .add(FamilyTreeLoadingEvent());
                    });
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: heightOfNode / 3,
                  ),
                ),
              ],
            ),
            Container(
              height: heightOfNode - heightOfNode / 3,
              width: widthOfNode,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: node.isPatient ? Colors.blue.shade200 : null,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    node.gender == "F" ? Icons.female : Icons.male,
                    color: node.gender == "F" ? Colors.pink : Colors.blue,
                    size: heightOfNode / 2,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      node.name,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => FamilyTreeBloc(),
                            ),
                            BlocProvider(
                              create: (context) => NodeDataBloc(),
                            )
                          ],
                          child: EditNodeData(
                            node: node,
                          ),
                        ),
                      ).then((value) {
                      context
                          .read<FamilyTreeBloc>()
                          .add(FamilyTreeLoadingEvent());
                    });
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      size: heightOfNode / 3,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

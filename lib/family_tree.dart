library family_tree;

export 'package:family_tree/family_tree.dart';
export 'package:family_tree/widgets/family_node_widget.dart';
export 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';

import 'package:family_tree/bloc/details_pannel_visibility/details_pannel_visibility_cubit.dart';
import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/widgets/family_node_widget.dart';
import 'package:family_tree/widgets/family_tree_drawing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FamilyTree extends StatelessWidget {
  const FamilyTree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();
    return BlocProvider(
      create: (context) => FamilyTreeBloc(),
      child: Builder(builder: (context) {
        context.read<FamilyTreeBloc>().add(FamilyTreeVisibleNodeLoadingEvent());
        return BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
          builder: (context, state) {
            if (state is FamilyTreeVisibleNodesLoaded) {
              if (state.nodes.isNotEmpty) {
                return BlocProvider(
                  create: (context) => DetailsPanelVisibilityCubit(),
                  child: Builder(builder: (context) {
                    context.watch<DetailsPanelVisibilityCubit>();
                    return BlocBuilder<DetailsPanelVisibilityCubit,
                        DetailsPannelVisibilityState>(
                      builder: (context, pannelVisibility) {
                        return Row(
                          children: [
                            Expanded(
                                child: InteractiveViewer(
                              constrained: false,
                              minScale: 0.0001,
                              maxScale: 8.0,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top:50,
                                    left:50,right: 50),
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  controller: verticalScrollController,
                                  child: SingleChildScrollView(
                                    controller: horizontalScrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                      width: state.viewPortWidth == 0.0
                                          ? MediaQuery.of(context).size.width
                                          : state.viewPortWidth,
                                      height: state.viewPortHeight == 0.0
                                          ? MediaQuery.of(context).size.height
                                          : state.viewPortHeight,
                                      child: Stack(
                                        children: [
                                          FamilyTreeDrawing(
                                            nodes: state.nodes,
                                            horizontalGap: state.horizontalGap,
                                            nodeHeight: state.heightOfNode,
                                            nodeWidth: state.widthOfNode,
                                            verticalGap: state.verticalGap,
                                            height: state.viewPortHeight,
                                            width: state.viewPortWidth,
                                          ),
                                          for (var node in state.nodes)
                                            FamilyNodeWidget(
                                              node: node,
                                              widthOfNode: state.widthOfNode,
                                              heightOfNode: state.heightOfNode,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                            if (pannelVisibility.isPannelVisible)
                              Builder(builder: (context) {
                                var node = state.nodes.firstWhere((element) =>
                                    element.id ==
                                    pannelVisibility.lastViewedNodeId);

                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          left:
                                              BorderSide(color: Colors.grey))),
                                  width: 400,
                                  margin: const EdgeInsets.only(left: 20),
                                  padding: const EdgeInsets.all(20),
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          node.name,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: node.gender == "F"
                                                  ? Colors.pink
                                                  : Colors.blue),
                                        ),
                                      ),
                                      Text(
                                        "Gender: ${node.gender == "M" ? "Male" : node.gender == "F" ? "Female" : "Others"}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Date of birth: ${node.dateOfBirth}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "Date of death: ${node.dateOfBirth}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          ],
                        );
                      },
                    );
                  }),
                );
              } else {
                return const Center(child: Text('Tree not found.....'));
              }
            } else {
              return const Center(child: Text('Loading.....'));
            }
          },
        );
      }),
    );
  }
}

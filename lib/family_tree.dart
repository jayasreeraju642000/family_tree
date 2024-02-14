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
import 'package:zoom_widget/zoom_widget.dart';

class FamilyTree extends StatelessWidget {
  final Widget? child;
  const FamilyTree({
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => FamilyTreeBloc(),
        ),
        BlocProvider(
          create: (ctx) => DetailsPanelVisibilityCubit(),
        ),
      ],
      child: Builder(builder: (builderContext) {
        builderContext
            .read<FamilyTreeBloc>()
            .add(FamilyTreeVisibleNodeLoadingEvent());
        builderContext.watch<DetailsPanelVisibilityCubit>();

        return BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
          builder: (familyBlocContext, state) {
            if (state is FamilyTreeVisibleNodesLoaded) {
              if (state.nodes.isNotEmpty) {
                return BlocBuilder<DetailsPanelVisibilityCubit,
                    DetailsPannelVisibilityState>(
                  builder: (context, pannelVisibility) {
                    return Row(
                      children: [
                        Expanded(
                            child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              controller: verticalScrollController,
                              child: SingleChildScrollView(
                                controller: horizontalScrollController,
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: state.viewPortWidth <
                                          MediaQuery.of(context).size.width
                                      ? MediaQuery.of(context).size.width
                                      : state.viewPortWidth,
                                  height: state.viewPortHeight <
                                          MediaQuery.of(context).size.height
                                      ? MediaQuery.of(context).size.height
                                      : state.viewPortHeight,
                                  child: Zoom(
                                    maxZoomHeight: state.viewPortWidth >
                                            MediaQuery.of(context).size.width
                                        ? state.viewPortWidth * 4
                                        : state.viewPortHeight,
                                    maxZoomWidth: state.viewPortWidth * 4,
                                    // initTotalZoomOut: true,
                                    scrollWeight: 5.0,
                                    initPosition: const Offset(0, 0),
                                    enableScroll: true,
                                    colorScrollBars:
                                        Theme.of(context).dividerColor,
                                    doubleTapZoom: true,
                                    centerOnScale: true,
                                    canvasColor: Theme.of(context).canvasColor,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    zoomSensibility: 0.05,
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
                                            // child: child,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                        if (pannelVisibility.isPannelVisible)
                          if (state.nodes.indexWhere((element) =>
                                  element.id ==
                                  pannelVisibility.lastViewedNodeId) !=
                              -1)
                            Builder(builder: (context) {
                              var node = state.nodes.firstWhere((element) =>
                                  element.id ==
                                  pannelVisibility.lastViewedNodeId);

                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: Colors.grey))),
                                width: 400,
                                margin: const EdgeInsets.only(left: 20),
                                padding: const EdgeInsets.all(20),
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Gender: //${node.gender == "M" ? "Male" : node.gender == "F" ? "Female" : "Others"}",
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

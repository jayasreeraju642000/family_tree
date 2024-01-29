library family_tree;

export 'package:family_tree/family_tree.dart';
export 'package:family_tree/widgets/family_node_widget.dart';
export 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';

import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/widgets/family_node_widget.dart';
import 'package:family_tree/widgets/family_tree_drawing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<ScaffoldState> homePageKey = GlobalKey<ScaffoldState>();

class FamilyTree extends StatelessWidget {
  const FamilyTree({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FamilyTreeBloc(),
      child: Builder(builder: (context) {
        context.read<FamilyTreeBloc>().add(FamilyTreeLoadingEvent());

        return Scaffold(
          key: homePageKey,
          body: BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FamilyTreeLoaded) {
                return InteractiveViewer(
                    constrained: false,
                    minScale: 0.0001,
                    maxScale: 8.0,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: state.verticalGap / 2,
                          left: state.horizontalGap / 2),
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
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
                    ));
              } else {
                return const Center(child: Text('Loading.....'));
              }
            },
          ),
        );
      }),
    );
  }
}

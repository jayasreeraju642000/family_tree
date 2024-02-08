import 'package:family_tree/bloc/details_pannel_visibility/details_pannel_visibility_cubit.dart';
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
  final Widget? child;
  const FamilyNodeWidget(
      {Key? key,
      required this.node,
      required this.heightOfNode,
      required this.widthOfNode,
      this.child,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsPanelVisibilityCubit,
        DetailsPannelVisibilityState>(
      builder: (context, state) {
        return BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
          builder: (context, state) {
            if (state is FamilyTreeVisibleNodesLoaded) {
              return Positioned(
                top: node.yCoordinates,
                left: node.xCoordinate,
                child: child ??
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: widthOfNode,
                      height: heightOfNode,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (hasNewItem(
                                      state.nodes.map((e) => e.id).toList(),
                                      node.relationData
                                          .map((e) => e.relatedUserId)
                                          .toList()) ||
                                  FamilyTreeBloc.nodeFamiliesExpandedId
                                      .containsKey(node.id)) ...{
                                InkWell(
                                  onTap: () {
                                    context.read<FamilyTreeBloc>().add(
                                        UpdateVisibilityOfRelatedNodes(
                                            node: node,
                                            isExpanded: FamilyTreeBloc
                                                        .nodeFamiliesExpandedId[
                                                    node.id] ==
                                                true));
                                  },
                                  child: Icon(
                                    FamilyTreeBloc.nodeFamiliesExpandedId[
                                                node.id] ==
                                            true
                                        ? Icons.person_outlined
                                        : Icons.groups_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              },
                              const Spacer(),
                              Text(
                                '${(node.dateOfBirth ?? 'NA').split('-').last} - ${(node.dateOfDeath ?? 'NA').split('-').last}',
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
                                    context.read<FamilyTreeBloc>().add(
                                        FamilyTreeVisibleNodeLoadingEvent());
                                  });
                                },
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              context
                                  .read<DetailsPanelVisibilityCubit>()
                                  .onVisibilityChange(node.id);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: heightOfNode - 20,
                                  width: widthOfNode,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: node.isPatient
                                        ? Colors.blue.shade200
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              node.gender == "F"
                                                  ? Icons.female
                                                  : node.gender == "M"
                                                      ? Icons.male
                                                      : Icons.transgender,
                                              color: node.gender == "F"
                                                  ? Colors.pink
                                                  : node.gender == "M"
                                                      ? Colors.blue
                                                      : Colors.purple,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                node.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showAdaptiveDialog(
                                            context: context,
                                            builder: (context) =>
                                                MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) =>
                                                      FamilyTreeBloc(),
                                                ),
                                                BlocProvider(
                                                  create: (context) =>
                                                      NodeDataBloc(),
                                                )
                                              ],
                                              child: EditNodeData(
                                                node: node,
                                              ),
                                            ),
                                          ).then((value) {
                                            context.read<FamilyTreeBloc>().add(
                                                FamilyTreeVisibleNodeLoadingEvent());
                                          });
                                        },
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    left: 10,
                                    bottom: 2,
                                    child: InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }

  bool hasNewItem(List<int> first, List<int> second) {
    for (var item in second) {
      if (!first.contains(item)) {
        return true;
      }
    }
    return false;
  }
}

import 'package:family_tree/bloc/details_pannel_visibility/details_pannel_visibility_cubit.dart';
import 'package:family_tree/constants/iconfiles/iconfiles.dart';
import 'package:family_tree/data/data.dart';
import 'package:family_tree/family_tree.dart';
import 'package:family_tree/widgets/add_relation.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                              ColoredBox(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Row(
                                  children: [
                                    // Text(
                                    //   '${(node.dateOfBirth ?? 'NA').split('-').last} - ${(node.dateOfDeath ?? 'NA').split('-').last}',
                                    //   style: const TextStyle(fontSize: 9),
                                    // ),
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showAdaptiveDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => EditNodeData(
                                            node: node,
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
                            child: Container(
                              height: heightOfNode - 20,
                              width: widthOfNode,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: node.isAffected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                border: node.isPatient
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)
                                    : Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          node.gender == "F" &&
                                                  node.isAlive == true &&
                                                  node.isTwin == false
                                              ? SvgPicture.asset(
                                                  height: 50,
                                                  width: 50,
                                                  IconFiles.female)
                                              : node.gender == "F" &&
                                                      node.isAlive == false &&
                                                      node.isTwin == false
                                                  ? SvgPicture.asset(
                                                      height: 50,
                                                      width: 50,
                                                      IconFiles.femaledead)
                                                  : node.gender == "M" &&
                                                          node.isAlive ==
                                                              true &&
                                                          node.isTwin == false
                                                      ? SvgPicture.asset(
                                                          height: 50,
                                                          width: 50,
                                                          IconFiles.male)
                                                      : node.gender == "M" &&
                                                              node.isAlive ==
                                                                  false &&
                                                              node.isTwin ==
                                                                  false
                                                          ? SvgPicture.asset(
                                                              height: 50,
                                                              width: 50,
                                                              IconFiles
                                                                  .maledead)
                                                          : node.gender == "M" &&
                                                                  node.isTwin ==
                                                                      true &&
                                                                  node.isAlive ==
                                                                      true
                                                              ? SvgPicture.asset(
                                                                  height: 50,
                                                                  width: 50,
                                                                  IconFiles
                                                                      .maletwin)
                                                              : node.gender ==
                                                                          "M" &&
                                                                      node.isTwin ==
                                                                          true &&
                                                                      node.isAlive ==
                                                                          false
                                                                  ? SvgPicture.asset(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      IconFiles
                                                                          .maletwindead)
                                                                  : node.gender == "F" &&
                                                                          node.isTwin ==
                                                                              true &&
                                                                          node.isAlive ==
                                                                              false
                                                                      ? SvgPicture.asset(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              50,
                                                                          IconFiles
                                                                              .femaletwindead)
                                                                      : node.gender == "F" &&
                                                                              node.isTwin == true &&
                                                                              node.isAlive == true
                                                                          ? SvgPicture.asset(height: 50, width: 50, IconFiles.femaletwin)
                                                                          : const SizedBox(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                node.ispregnant == true
                                                    ? SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles.pregnancyyes)
                                                    : SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles.pregnancyno),
                                                node.isConsagnious == true
                                                    ? SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles
                                                            .consanguinousyes)
                                                    : SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles
                                                            .consanguinousno),
                                                node.isGenetictestdone == true
                                                    ? SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles
                                                            .genetictestdoneyes)
                                                    : SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles
                                                            .genetictestdoneno),
                                                node.lossofbaby == true
                                                    ? SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles.lossofbabyyes)
                                                    : SvgPicture.asset(
                                                        height: 25,
                                                        width: 25,
                                                        IconFiles.lossofbabyyes)
                                              ],
                                            ),
                                          ),
                                          const Divider(),
                                          Text(
                                            node.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${(node.dateOfBirth ?? 'NA').split('-').last} - ${(node.dateOfDeath ?? 'NA').split('-').last}',
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // child: Row(
                                    //   children: [
                                    //     Icon(
                                    //       node.gender == "F"
                                    //           ? Icons.female
                                    //           : node.gender == "M"
                                    //               ? Icons.male
                                    //               : Icons.transgender,
                                    //       color: node.gender == "F"
                                    //           ? Colors.pink
                                    //           : node.gender == "M"
                                    //               ? Colors.blue
                                    //               : Colors.purple,
                                    //       size: 20,
                                    //     ),
                                    //     const SizedBox(
                                    //       width: 5,
                                    //     ),
                                    // Expanded(
                                    //   child: Text(
                                    //     node.name,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyMedium,
                                    //   ),
                                    // ),
                                    //   ],
                                    // ),
                                  ),
                                ],
                              ),
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

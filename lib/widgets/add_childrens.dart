import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/data/data.dart';

class AddChildView extends StatelessWidget {
  final Person node;
  const AddChildView({
    Key? key,
    required this.node,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<FamilyTreeBloc>().add(FamilyTreeAllNodeLoadingEvent());
    Person? partner;

    TextEditingController nameController = TextEditingController();
    TextEditingController yearOfBirthController = TextEditingController();
    TextEditingController yearOfDeathController = TextEditingController();
    return BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FamilyTreeAllNodesLoaded) {
          return AlertDialog(
            title: Row(
              children: [
                const Expanded(child: Text("Add Child")),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Person>(
                  value: partner,
                  decoration: InputDecoration(
                      label: const Text("Name of Father: "),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  hint: const Text("Select an option"),
                  onChanged: (value) {
                    if (value?.id == -1) {
                      // _showAddNewItemDialog(
                      //     context, state.nodes, state.verticalGap, value!);
                    } else {
                      partner = value;
                    }
                  },
                  items: state.nodes
                      .where((element) =>
                          element.level == node.level - 1 &&
                          element.gender == "M")
                      .toList()
                      .map(
                        (e) => DropdownMenuItem<Person>(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList()
                    ..add(DropdownMenuItem(
                      value: Person(
                          id: -1,
                          name: '',
                          gender: node.gender == "M" ? "F" : "M",
                          level: node.level,
                          xCoordinate: node.xCoordinate,
                          yCoordinates: node.yCoordinates - state.verticalGap,
                          relationData: [
                            RelationData(
                                relatedUserId: node.id, relationTypeId: 2)
                          ]),
                      child: const Text("Add New..."),
                    )),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<NodeDataBloc, NodeDataState>(
                  builder: (context, state) {
                    if (state is NodeDataLoaded) {
                      return Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                label: const Text(
                                  "Name",
                                  style: TextStyle(fontSize: 12),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            Expanded(
                              child: TextField(
                                controller: yearOfBirthController
                                  ..text = state.yearOfBirth == null
                                      ? ''
                                      : state.yearOfBirth.toString(),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    label: const Text(
                                      "Year of Birth",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: yearOfDeathController
                                  ..text = state.yearOfDeath == null
                                      ? ''
                                      : state.yearOfDeath.toString(),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    label: const Text(
                                      "Year of death",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: const Text('Male'),
                                  leading: Radio<Gender>(
                                    value: Gender.male,
                                    groupValue: state.gender,
                                    onChanged: (Gender? value) {
                                      context.read<NodeDataBloc>().add(
                                            ChangeData(
                                              gender: value!,
                                              name:
                                                  nameController.text.isNotEmpty
                                                      ? nameController.text
                                                      : node.name,
                                              yearOfDeath:
                                                  int.tryParse(
                                                      yearOfDeathController
                                                              .text.isNotEmpty
                                                          ? yearOfDeathController
                                                              .text
                                                              .trim()
                                                          : node.yearOfDeath
                                                              .toString()),
                                              yearOfBirth: int.tryParse(
                                                  yearOfBirthController
                                                          .text.isNotEmpty
                                                      ? yearOfBirthController
                                                          .text
                                                      : node.yearOfBirth
                                                          .toString()),
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Female'),
                                  leading: Radio<Gender>(
                                    value: Gender.female,
                                    groupValue: state.gender,
                                    onChanged: (Gender? value) {
                                      context.read<NodeDataBloc>().add(
                                            ChangeData(
                                              gender: value!,
                                              name:
                                                  nameController.text.isNotEmpty
                                                      ? nameController.text
                                                      : node.name,
                                              yearOfDeath:
                                                  int.tryParse(
                                                      yearOfDeathController
                                                              .text.isNotEmpty
                                                          ? yearOfDeathController
                                                              .text
                                                              .trim()
                                                          : node.yearOfDeath
                                                              .toString()),
                                              yearOfBirth: int.tryParse(
                                                  yearOfBirthController
                                                          .text.isNotEmpty
                                                      ? yearOfBirthController
                                                          .text
                                                      : node.yearOfBirth
                                                          .toString()),
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (partner != null) {
                    // context.read<FamilyTreeBloc>().add(AddChildrenEvent(
                    //     node: node, partner: partner!, child: Person(id: -1, name: nameController.text, gender: g, level: level, relationData: relationData)!));
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
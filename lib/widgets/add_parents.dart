import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/data/data.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AddParents extends StatelessWidget {
  final Person node;
  AddParents({
    Key? key,
    required this.node,
  }) : super(key: key);
  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final dateOfDeathController = TextEditingController();
  Gender gender = Gender.male;
  @override
  Widget build(BuildContext context) {
    context.read<FamilyTreeBloc>().add(FamilyTreeAllNodeLoadingEvent());
    Person? father;
    Person? mother;
    return BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FamilyTreeAllNodesLoaded) {
          return AlertDialog(
            title: Row(
              children: [
                const Expanded(child: Text("Add Parents")),
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
                  value: father,
                  decoration: InputDecoration(
                      label: const Text("Name of Father: "),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  hint: const Text("Select an option"),
                  onChanged: (value) {
                    if (value?.id == -1) {
                      _showAddNewItemDialog(
                        context,
                        state.nodes,
                        state.verticalGap,
                        value!,
                        state,
                      );
                    } else {
                      father = value;
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
                          gender: "M",
                          level: node.level - 1,
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
                DropdownButtonFormField<Person>(
                  value: mother,
                  hint: const Text("Select an option"),
                  decoration: InputDecoration(
                      label: const Text("Name of Mother: "),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onChanged: (value) {
                    if (value?.id == -1) {
                      _showAddNewItemDialog(
                        context,
                        state.nodes,
                        state.verticalGap,
                        value!,
                        state,
                      );
                    } else {
                      mother = value;
                    }
                  },
                  items: state.nodes
                      .where((element) =>
                          element.level == node.level - 1 &&
                          element.gender == "F")
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
                          gender: "F",
                          level: node.level - 1,
                          xCoordinate: node.xCoordinate +
                              state.widthOfNode +
                              state.horizontalGap,
                          yCoordinates: node.yCoordinates - state.verticalGap,
                          relationData: [
                            RelationData(
                                relatedUserId: node.id, relationTypeId: 2)
                          ]),
                      child: const Text("Add New..."),
                    )),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (father != null && mother != null) {
                    context.read<FamilyTreeBloc>().add(UpdateOrAddParents(
                        child: node, father: father!, mother: mother!));
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

  void _showAddNewItemDialog(
    BuildContext context,
    List<Person> nodes,
    double verticalGap,
    Person parent,
    FamilyTreeAllNodesLoaded state,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: BlocProvider(
            create: (context) => NodeDataBloc(),
            child: Builder(builder: (context) {
              context.read<NodeDataBloc>().add(LoadData(
                    gender: Gender.male,
                    name: '',
                  ));
              return childContainer(context, state);
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  _addNewItem(
                      context,
                      parent.copyWith(
                          id: nodes.length + 1,
                          name: nameController.text.trim(),
                          dateOfBirth: dateOfBirthController.text.trim(),
                          dateOfDeath: dateOfDeathController.text.trim(),
                          level: node.level - 1,
                          gender: gender == Gender.male
                              ? "M"
                              : gender == Gender.female
                                  ? "F"
                                  : "O",
                          relationData: [
                            RelationData(
                              relatedUserId: node.id,
                              relationTypeId: 2,
                            )
                          ]));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(BuildContext context, Person newItem) {
    if (context.read<FamilyTreeBloc>().state is FamilyTreeAllNodesLoaded) {
      if (!(context.read<FamilyTreeBloc>().state as FamilyTreeAllNodesLoaded)
          .nodes
          .contains(newItem)) {
        context
            .read<FamilyTreeBloc>()
            .add(AddFamilyNodeEvent(node: newItem, isFromAddParents: true));
        // Future.delayed(const Duration(microseconds: 50));
        // homePageKey.currentContext!
        //     .read<FamilyTreeBloc>()
        //     .add(AddFamilyNodeEvent(node: newItem));
      }
      Navigator.of(context).pop();
    }
  }

  Column childContainer(BuildContext context, FamilyTreeAllNodesLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                      child: TextFormField(
                        controller: dateOfBirthController,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) => dateOfBirthValidator(
                          value,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          label: const Text(
                            "Date of Birth",
                            style: TextStyle(fontSize: 12),
                          ),
                          suffixIcon: InkWell(
                              onTap: () =>
                                  _showDatePicker(context, gender, true),
                              child: const Icon(Icons.calendar_month)),
                          hintText: "dd-MM-yyyy",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: dateOfDeathController,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) => dateOfDeathValidator(
                          value,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          suffixIcon: InkWell(
                              onTap: () =>
                                  _showDatePicker(context, gender, false),
                              child: const Icon(Icons.calendar_month)),
                          label: const Text(
                            "Date of death",
                            style: TextStyle(fontSize: 12),
                          ),
                          hintText: "dd-MM-yyyy",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                        ),
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
                            groupValue: gender,
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender,
                                        name: nameController.text,
                                        dateOfDeath: dateOfDeathController.text,
                                        dateOfBirth: dateOfBirthController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Female'),
                          leading: Radio<Gender>(
                            value: Gender.female,
                            groupValue: gender,
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender,
                                        name: nameController.text,
                                        dateOfDeath: dateOfDeathController.text,
                                        dateOfBirth: dateOfBirthController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Others'),
                          leading: Radio<Gender>(
                            value: Gender.other,
                            groupValue: gender,
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender,
                                        name: nameController.text,
                                        dateOfDeath: dateOfDeathController.text,
                                        dateOfBirth: dateOfBirthController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
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
    );
  }

  void _showDatePicker(
      BuildContext context, Gender gender, bool isDateOfBirth) async {
    var dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
      onDatePickerModeChange: (value) {},
    );
    if (dateTime != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);
      // String formattedDate =
      //     "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString()}";
      if (context.mounted) {
        if (isDateOfBirth) {
          dateOfBirthController.text = formattedDate;
        } else {
          dateOfDeathController.text = formattedDate;
        }
        context.read<NodeDataBloc>().add(
              ChangeData(
                gender: gender,
                name: nameController.text,
                dateOfDeath:
                    !isDateOfBirth ? formattedDate : dateOfDeathController.text,
                dateOfBirth:
                    isDateOfBirth ? formattedDate : dateOfBirthController.text,
              ),
            );
      }
    }
  }

  String? dateOfBirthValidator(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        dateOfDeathController.text.trim().isNotEmpty) {
      if (DateFormat('dd-MM-yyyy').parse(value.trim()).compareTo(
              DateFormat('dd-MM-yyyy')
                  .parse(dateOfDeathController.text.trim())) >
          0) {
        return "Date of Birth should be before date of death";
      }
    }
    return null;
  }

  String? dateOfDeathValidator(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        dateOfBirthController.text.trim().isNotEmpty) {
      if (DateFormat('dd-MM-yyyy').parse(value.trim()).compareTo(
              DateFormat('dd-MM-yyyy')
                  .parse(dateOfBirthController.text.trim())) <
          0) {
        return "Date of death should be after date of birth";
      }
    }
    return null;
  }
}

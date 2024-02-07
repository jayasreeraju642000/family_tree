import 'package:family_tree/bloc/counter_cubit/counter_cubit.dart';
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
    context.read<NodeDataBloc>().add(LoadData(
          gender: Gender.male,
          name: '',
        ));
    List<Person?> partner = [];
    List<Gender> gender = [];
    List<TextEditingController> nameController = [];
    List<TextEditingController> dateOfBirthController = [];
    List<TextEditingController> dateOfDeathController = [];
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: Builder(builder: (context) {
        context.watch<CounterCubit>().state;

        return BlocBuilder<CounterCubit, CounterState>(
          builder: (context, counterState) {
            return Builder(builder: (context) {
              for (int i = 0; i < counterState.count; i++) {
                if (nameController.length < counterState.count) {
                  nameController.add(TextEditingController());
                }
                if (dateOfBirthController.length < counterState.count) {
                  dateOfBirthController.add(TextEditingController());
                }
                if (dateOfDeathController.length < counterState.count) {
                  dateOfDeathController.add(TextEditingController());
                }
                if (gender.length < counterState.count) gender.add(Gender.male);
                if (partner.length < counterState.count) partner.add(null);
              }
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
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            for (int i = 0; i < counterState.count; i++) ...{
                              childContainer(
                                  context,
                                  partner,
                                  i,
                                  gender,
                                  state,
                                  nameController,
                                  dateOfBirthController,
                                  dateOfDeathController),
                            }
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            const Text(
                              "No. of children: ",
                              style: TextStyle(fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                context.read<CounterCubit>().decrement();
                              },
                              child: const Icon(
                                Icons.remove,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${counterState.count}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                context.read<CounterCubit>().increment();
                              },
                              child: const Icon(
                                Icons.add,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (partner.isNotEmpty) {
                              for (int i = 0; i < counterState.count; i++) {
                                if (partner[i] != null) {
                                  context.read<FamilyTreeBloc>().add(
                                        AddChildrenEvent(
                                          node: node,
                                          partner: partner[i]!,
                                          child: Person(
                                            id: -1,
                                            name: nameController[i].text,
                                            gender: gender[i] == Gender.female
                                                ? "F"
                                                : gender[i] == Gender.male
                                                    ? "M"
                                                    : "O",
                                            level: node.level + 1,
                                            relationData: [
                                              RelationData(
                                                relatedUserId: node.id,
                                                relationTypeId: 1,
                                              ),
                                              RelationData(
                                                relatedUserId: partner[i]!.id,
                                                relationTypeId: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                }
                              }
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
            });
          },
        );
      }),
    );
  }

  Column childContainer(
      BuildContext context,
      List<Person?> partner,
      int i,
      List<Gender> gender,
      FamilyTreeAllNodesLoaded state,
      List<TextEditingController> nameController,
      List<TextEditingController> dateOfBirthController,
      List<TextEditingController> dateOfDeathController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<Person>(
          value: partner.isNotEmpty && partner.length > i ? partner[i] : null,
          decoration: InputDecoration(
              label: const Text("Name of Partner: "),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          hint: const Text("Select an option"),
          onChanged: (value) {
            if (value?.id == -1) {
              _showAddNewItemDialog(
                  context, state.nodes, state.verticalGap, value!);
            } else if (value != null && value.id != -1) {
              if (partner.length > i) {
                partner[i] = value;
              } else {
                partner.add(value);
              }
            }
          },
          items: state.nodes
              .where((element) =>
                  element.level == node.level &&
                  element.gender == (node.gender == "F" ? "M" : "F"))
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
                    relatedUserId: node.id,
                    relationTypeId: 2,
                  )
                ],
              ),
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
                    controller: nameController[i],
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
                        controller: dateOfBirthController[i],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          label: const Text(
                            "Date of Birth",
                            style: TextStyle(fontSize: 12),
                          ),
                          suffixIcon: InkWell(
                              onTap: () => _showDatePicker(
                                  context,
                                  partner,
                                  i,
                                  gender,
                                  nameController,
                                  dateOfBirthController,
                                  dateOfDeathController,
                                  true),
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
                      child: TextField(
                        controller: dateOfDeathController[i],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          suffixIcon: InkWell(
                              onTap: () => _showDatePicker(
                                  context,
                                  partner,
                                  i,
                                  gender,
                                  nameController,
                                  dateOfBirthController,
                                  dateOfDeathController,
                                  true),
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
                            groupValue: gender[i],
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender[i] = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender[i],
                                        name: nameController[i].text,
                                        dateOfDeath:
                                            dateOfDeathController[i].text,
                                        dateOfBirth:
                                            dateOfBirthController[i].text,
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
                            groupValue: gender[i],
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender[i] = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender[i],
                                        name: nameController[i].text,
                                        dateOfDeath:
                                            dateOfDeathController[i].text,
                                        dateOfBirth:
                                            dateOfBirthController[i].text,
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
                            groupValue: gender[i],
                            onChanged: (Gender? value) {
                              if (value != null) {
                                gender[i] = value;
                                context.read<NodeDataBloc>().add(
                                      ChangeData(
                                        gender: gender[i],
                                        name: nameController[i].text,
                                        dateOfDeath:
                                            dateOfDeathController[i].text,
                                        dateOfBirth:
                                            dateOfBirthController[i].text,
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

  void _showAddNewItemDialog(BuildContext context, List<Person> nodes,
      double verticalGap, Person parent) {
    showDialog(
      context: context,
      builder: (ctx) {
        String newItem = '';
        return AlertDialog(
          title: const Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: const InputDecoration(hintText: "Enter new item"),
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
                if (newItem.isNotEmpty) {
                  _addNewItem(
                      context,
                      parent.copyWith(
                          id: nodes.length + 1,
                          name: newItem,
                          relationData: [
                            RelationData(
                              relatedUserId: node.id,
                              relationTypeId: 2,
                            )
                          ]));
                  Navigator.of(context).pop();
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
    }
  }

  void _showDatePicker(
      BuildContext context,
      List<Person?> partner,
      int i,
      List<Gender> gender,
      List<TextEditingController> nameController,
      List<TextEditingController> dateOfBirthController,
      List<TextEditingController> dateOfDeathController,
      bool isDateOfBirth) async {
    var dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime(4000),
      onDatePickerModeChange: (value) {},
    );
    if (dateTime != null) {
      String formattedDate =
          "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString()}";
      if (context.mounted) {
        if (isDateOfBirth) {
          dateOfBirthController[i].text = formattedDate;
        } else {
          dateOfDeathController[i].text = formattedDate;
        }
        context.read<NodeDataBloc>().add(
              ChangeData(
                gender: gender[i],
                name: nameController[i].text,
                dateOfDeath: !isDateOfBirth
                    ? formattedDate
                    : dateOfDeathController[i].text,
                dateOfBirth: isDateOfBirth
                    ? formattedDate
                    : dateOfBirthController[i].text,
              ),
            );
      }
    }
  }


}

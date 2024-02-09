import 'package:family_tree/bloc/add_parent_visibility/add_parents_visibility_cubit.dart';
import 'package:family_tree/bloc/counter_cubit/counter_cubit.dart';
import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/add_parents.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:family_tree/family_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';
import 'package:intl/intl.dart';

class AddSiblingView extends StatelessWidget {
  final Person node;
  const AddSiblingView({super.key, required this.node});
  @override
  Widget build(BuildContext context) {
    final familyTreeBloc = context.read<FamilyTreeBloc>();
    familyTreeBloc.add(FamilyTreeAllNodeLoadingEvent());
    context.read<NodeDataBloc>().add(LoadData(
          gender: Gender.male,
          name: '',
        ));
    List<Gender> gender = [];
    List<TextEditingController> nameController = [];
    List<TextEditingController> dateOfBirthController = [];
    List<TextEditingController> dateOfDeathController = [];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CounterCubit(),
        ),
        BlocProvider(
          create: (context) => AddParentsVisibilityCubit(),
        )
      ],
      child: Builder(builder: (context) {
        context.watch<CounterCubit>().state;
        context.watch<AddParentsVisibilityCubit>().state;
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
              }
              return BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is FamilyTreeAllNodesLoaded) {
                    return BlocBuilder<AddParentsVisibilityCubit,
                        AddParentsVisibilityState>(
                      builder: (context, parentCheckBoxstate) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              const Expanded(child: Text("Add Siblings")),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: node.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    children: [
                                      TextSpan(
                                        text: " (${node.gender})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400),
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Date of birth: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                    children: [
                                      TextSpan(
                                        text: node.dateOfBirth,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Date of death: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                    children: [
                                      TextSpan(
                                        text: node.dateOfDeath,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (!node.relationData.any((element) =>
                                  element.relationTypeId == 1)) ...{
                                const Text(
                                    "If there is no parent data, siblings with unknown parents will be created."),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: parentCheckBoxstate
                                          .isAddParentChecked,
                                      onChanged: (value) {
                                        context
                                            .read<AddParentsVisibilityCubit>()
                                            .change(
                                                value: value!,
                                                fatherData:
                                                    parentCheckBoxstate.father,
                                                motherData:
                                                    parentCheckBoxstate.mother);
                                      },
                                    ),
                                    const Text("Add Parents")
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                if (parentCheckBoxstate.isAddParentChecked) ...{
                                  AddParents(
                                    node: node,
                                    addParentsVisibilityState:
                                        parentCheckBoxstate,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                }
                              },
                              for (int i = 0; i < counterState.count; i++) ...{
                                childContainer(
                                  context,
                                  i,
                                  gender,
                                  state,
                                  nameController,
                                  dateOfBirthController,
                                  dateOfDeathController,
                                ),
                              }
                            ],
                          )),
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
                                for (int i = 0; i < counterState.count; i++) {
                                  if (familyTreeBloc.state
                                      is FamilyTreeAllNodesLoaded) {
                                    var sibling = Person(
                                        id: -1,
                                        level: node.level,
                                        name: nameController[i].text,
                                        dateOfDeath: dateOfDeathController[i]
                                            .text
                                            .trim(),
                                        dateOfBirth: dateOfBirthController[i]
                                            .text
                                            .trim(),
                                        gender: gender[i] == Gender.female
                                            ? "F"
                                            : gender[i] == Gender.male
                                                ? "M"
                                                : "O",
                                        relationData: []);
                                    if (node.relationData.any((element) =>
                                        element.relationTypeId == 1)) {
                                      var parentIds = node.relationData
                                          .where((element) =>
                                              element.relationTypeId == 1)
                                          .toList()
                                          .map((item) => item.relatedUserId);
                                      if (parentIds.isNotEmpty) {
                                        var parents = parentIds
                                            .map((e) => FamilyTreeBloc.nodes
                                                .firstWhere((element) =>
                                                    element.id == e))
                                            .toList();
                                        if (parents.isNotEmpty) {
                                          familyTreeBloc.add(
                                            AddSiblingEvent(
                                                node: node,
                                                father: parents.firstWhere(
                                                    (element) =>
                                                        element.gender == "M"),
                                                mother: parents.firstWhere(
                                                    (element) =>
                                                        element.gender == "F"),
                                                sibling: sibling
                                                    .copyWith(relationData: [
                                                  RelationData(
                                                      relatedUserId: parents
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .gender ==
                                                                  "M")
                                                          .id,
                                                      relationTypeId: 1),
                                                  RelationData(
                                                      relatedUserId: parents
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .gender ==
                                                                  "F")
                                                          .id,
                                                      relationTypeId: 1)
                                                ])),
                                          );
                                        }
                                      }
                                    } else {
                                      if (parentCheckBoxstate.father != null &&
                                          parentCheckBoxstate.mother != null) {
                                        familyTreeBloc.add(
                                          AddSiblingEvent(
                                            node: node,
                                            sibling:
                                                sibling.copyWith(relationData: [
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .father!.id,
                                                  relationTypeId: 1),
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .mother!.id,
                                                  relationTypeId: 1)
                                            ]),
                                            father: parentCheckBoxstate.father!,
                                            mother: parentCheckBoxstate.mother!,
                                          ),
                                        );
                                      } else if (parentCheckBoxstate.father !=
                                              null &&
                                          parentCheckBoxstate.mother == null) {
                                        familyTreeBloc.add(
                                          AddSiblingEvent(
                                            node: node,
                                            sibling:
                                                sibling.copyWith(relationData: [
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .father!.id,
                                                  relationTypeId: 1),
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .mother!.id,
                                                  relationTypeId: 1)
                                            ]),
                                            father: parentCheckBoxstate.father!,
                                            mother: Person(
                                                id: -1,
                                                name: 'Mother (${node.name})',
                                                gender: "F",
                                                level: node.level - 1,
                                                xCoordinate: node.xCoordinate +
                                                    state.widthOfNode +
                                                    state.horizontalGap,
                                                yCoordinates:
                                                    node.yCoordinates -
                                                        state.verticalGap,
                                                relationData: [
                                                  RelationData(
                                                      relatedUserId: node.id,
                                                      relationTypeId: 2)
                                                ]),
                                          ),
                                        );
                                      } else if (parentCheckBoxstate.father ==
                                              null &&
                                          parentCheckBoxstate.mother != null) {
                                        familyTreeBloc.add(
                                          AddSiblingEvent(
                                            node: node,
                                            sibling:
                                                sibling.copyWith(relationData: [
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .father!.id,
                                                  relationTypeId: 1),
                                              RelationData(
                                                  relatedUserId:
                                                      parentCheckBoxstate
                                                          .mother!.id,
                                                  relationTypeId: 1)
                                            ]),
                                            mother: parentCheckBoxstate.mother!,
                                            father: Person(
                                                id: -1,
                                                name: 'Father (${node.name})',
                                                gender: "M",
                                                level: node.level - 1,
                                                xCoordinate: node.xCoordinate +
                                                    state.widthOfNode +
                                                    state.horizontalGap,
                                                yCoordinates:
                                                    node.yCoordinates -
                                                        state.verticalGap,
                                                relationData: [
                                                  RelationData(
                                                      relatedUserId: node.id,
                                                      relationTypeId: 2)
                                                ]),
                                          ),
                                        );
                                      } else {
                                        familyTreeBloc.add(
                                          AddSiblingEvent(
                                            node: node,
                                            sibling:
                                                sibling,
                                            mother: Person(
                                                id: -1,
                                                name: 'Mother (${node.name})',
                                                gender: "M",
                                                level: node.level - 1,
                                                xCoordinate: node.xCoordinate +
                                                    state.widthOfNode +
                                                    state.horizontalGap,
                                                yCoordinates:
                                                    node.yCoordinates -
                                                        state.verticalGap,
                                                relationData: [
                                                  RelationData(
                                                      relatedUserId: node.id,
                                                      relationTypeId: 2)
                                                ]),
                                            father: Person(
                                                id: -1,
                                                name: 'Father (${node.name})',
                                                gender: "M",
                                                level: node.level - 1,
                                                xCoordinate: node.xCoordinate +
                                                    state.widthOfNode +
                                                    state.horizontalGap,
                                                yCoordinates:
                                                    node.yCoordinates -
                                                        state.verticalGap,
                                                relationData: [
                                                  RelationData(
                                                      relatedUserId: node.id,
                                                      relationTypeId: 2)
                                                ]),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                              child: const Text("Save"),
                            )
                          ],
                        );
                      },
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
      int i,
      List<Gender> gender,
      FamilyTreeAllNodesLoaded state,
      List<TextEditingController> nameController,
      List<TextEditingController> dateOfBirthController,
      List<TextEditingController> dateOfDeathController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                      child: TextFormField(
                        controller: dateOfBirthController[i],
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) => dateOfBirthValidator(
                            value, dateOfDeathController, i),
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
                      child: TextFormField(
                        controller: dateOfDeathController[i],
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) => dateOfDeathValidator(
                            value, dateOfBirthController, i),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          suffixIcon: InkWell(
                              onTap: () => _showDatePicker(
                                  context,
                                  i,
                                  gender,
                                  nameController,
                                  dateOfBirthController,
                                  dateOfDeathController,
                                  false),
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

  void _showDatePicker(
      BuildContext context,
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
      lastDate: DateTime.now(),
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

  String? dateOfBirthValidator(
      String? value, List<TextEditingController> dateOfDeathController, int i) {
    if (value != null &&
        value.trim().isNotEmpty &&
        dateOfDeathController[i].text.trim().isNotEmpty) {
      if (DateFormat('dd-MM-yyyy').parse(value.trim()).compareTo(
              DateFormat('dd-MM-yyyy')
                  .parse(dateOfDeathController[i].text.trim())) >
          0) {
        return "Date of Birth should be before date of death";
      }
    }
    return null;
  }

  String? dateOfDeathValidator(
      String? value, List<TextEditingController> dateOfBirthController, int i) {
    if (value != null &&
        value.trim().isNotEmpty &&
        dateOfBirthController[i].text.trim().isNotEmpty) {
      if (DateFormat('dd-MM-yyyy').parse(value.trim()).compareTo(
              DateFormat('dd-MM-yyyy')
                  .parse(dateOfBirthController[i].text.trim())) <
          0) {
        return "Date of death should be after date of birth";
      }
    }
    return null;
  }
}

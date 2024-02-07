import 'package:family_tree/bloc/counter_cubit/counter_cubit.dart';
import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:family_tree/family_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';

class AddPartnerView extends StatelessWidget {
  final Person node;
  const AddPartnerView({super.key, required this.node});
  @override
  Widget build(BuildContext context) {
    context.read<FamilyTreeBloc>().add(FamilyTreeAllNodeLoadingEvent());
    context.read<NodeDataBloc>().add(LoadData(
          gender: Gender.male,
          name: '',
        ));
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
              }
              return BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is FamilyTreeAllNodesLoaded) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          const Expanded(child: Text("Add Partner")),
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
                            for (int i = 0; i < counterState.count; i++) {
                              context.read<FamilyTreeBloc>().add(
                                    AddPartnerNodeEvent(
                                      node: node,
                                      partnerNode: Person(
                                          id: -1,
                                          name: nameController[i].text,
                                          gender: gender[i] == Gender.male
                                              ? "M"
                                              : gender[i] == Gender.female
                                                  ? "F"
                                                  : "O",
                                          level: node.level,
                                          relationData: [
                                            RelationData(
                                                relatedUserId: node.id,
                                                relationTypeId: 0)
                                          ]),
                                    ),
                                  );
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

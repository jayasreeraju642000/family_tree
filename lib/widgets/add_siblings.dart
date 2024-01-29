
import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/edit_node_data.dart';
import 'package:family_tree/family_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';

class AddSiblings extends StatelessWidget {
  final FamilyModel node;
  const AddSiblings({super.key, required this.node});
  @override
  Widget build(BuildContext context) {
    context.read<NodeDataBloc>().add(
          LoadData(
            gender: node.gender == "M" ? Gender.male : Gender.female,
            name: node.name,
            yearOfBirth: node.yearOfBirth,
            yearOfDeath: node.yearOfDeath,
          ),
        );
    TextEditingController nameController = TextEditingController();
    TextEditingController yearOfBirthController = TextEditingController();
    TextEditingController yearOfDeathController = TextEditingController();

    return BlocBuilder<NodeDataBloc, NodeDataState>(
      builder: (context, state) {
        return state is NodeDataLoaded
            ? AlertDialog(
                title: const Text("Add Siblings"),
                content: SingleChildScrollView(
                  child: Column(
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
                             ,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              label: const Text(
                                "Year of Birth",
                                style: TextStyle(fontSize: 12),
                              ),
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
                            controller: yearOfDeathController
                             ,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              label: const Text(
                                "Year of death",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
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
                                groupValue: state.gender,
                                onChanged: (Gender? value) {
                                  context.read<NodeDataBloc>().add(
                                        ChangeData(
                                          gender: value!,
                                          name: nameController.text.isNotEmpty
                                              ? nameController.text
                                              : node.name,
                                          yearOfDeath: int.tryParse(
                                              yearOfDeathController
                                                      .text.isNotEmpty
                                                  ? yearOfDeathController.text
                                                      .trim()
                                                  : node.yearOfDeath
                                                      .toString()),
                                          yearOfBirth: int.tryParse(
                                            yearOfBirthController
                                                    .text.isNotEmpty
                                                ? yearOfBirthController.text
                                                : node.yearOfBirth.toString(),
                                          ),
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
                                          name: nameController.text.isNotEmpty
                                              ? nameController.text
                                              : node.name,
                                          yearOfDeath: int.tryParse(
                                            yearOfDeathController
                                                    .text.isNotEmpty
                                                ? yearOfDeathController.text
                                                    .trim()
                                                : node.yearOfDeath.toString(),
                                          ),
                                          yearOfBirth: int.tryParse(
                                            yearOfBirthController
                                                    .text.isNotEmpty
                                                ? yearOfBirthController.text
                                                : node.yearOfBirth.toString(),
                                          ),
                                        ),
                                      );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                    context.read<FamilyTreeBloc>().add(
                            UpdateFamilyTreeNodeEvent(
                                node: node,
                                name: nameController.text.isNotEmpty
                                    ? nameController.text
                                    : node.name,
                                yearOfDeath: int.tryParse(
                                    yearOfDeathController.text.isNotEmpty
                                        ? yearOfDeathController.text.trim()
                                        : node.yearOfDeath.toString()),
                                yearOfBirth: int.tryParse(
                                    yearOfBirthController.text.isNotEmpty
                                        ? yearOfBirthController.text
                                        : node.yearOfBirth.toString()),
                                gender:
                                    state.gender == Gender.female ? "F" : "M"),
                          );

                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

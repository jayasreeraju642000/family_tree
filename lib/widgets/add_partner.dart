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
    context.read<NodeDataBloc>().add(
          LoadData(
            gender: node.gender == "M" ? Gender.male : Gender.female,
            name: "",
            dateOfBirth: '',
            dateOfDeath: '',
          ),
        );
    TextEditingController nameController = TextEditingController();
    TextEditingController dateOfBirthController = TextEditingController();
    TextEditingController dateOfDeathController = TextEditingController();
    final familyTreeBloc = context.read<FamilyTreeBloc>();
    familyTreeBloc.add(FamilyTreeVisibleNodeLoadingEvent());
    return BlocBuilder<NodeDataBloc, NodeDataState>(
      builder: (context, state) {
        return state is NodeDataLoaded
            ? AlertDialog(
                title: const Text("Add Partner"),
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
                            controller: dateOfBirthController
                              ..text = state.dateOfBirth == null
                                  ? ''
                                  : state.dateOfBirth.toString(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              label: const Text(
                                "Date of Birth",
                                style: TextStyle(fontSize: 12),
                              ),
                              suffixIcon: InkWell(
                                  onTap: () =>
                                      _showDatePicker(context, true, state),
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
                            controller: dateOfDeathController
                              ..text = state.dateOfDeath == null
                                  ? ''
                                  : state.dateOfDeath.toString(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              suffixIcon: InkWell(
                                  onTap: () =>
                                      _showDatePicker(context, false, state),
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
                                groupValue: state.gender,
                                onChanged: (Gender? value) {
                                  context.read<NodeDataBloc>().add(
                                        ChangeData(
                                          gender: value!,
                                          name: nameController.text,
                                          dateOfDeath:
                                              dateOfDeathController.text,
                                          dateOfBirth:
                                              dateOfBirthController.text,
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
                                          name: nameController.text,
                                          dateOfDeath:
                                              (dateOfDeathController.text),
                                          dateOfBirth:
                                              (dateOfBirthController.text),
                                        ),
                                      );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Others'),
                              leading: Radio<Gender>(
                                value: Gender.other,
                                groupValue: state.gender,
                                onChanged: (Gender? value) {
                                  context.read<NodeDataBloc>().add(
                                        ChangeData(
                                          gender: value!,
                                          name: nameController.text,
                                          dateOfDeath:
                                              (dateOfDeathController.text),
                                          dateOfBirth:
                                              (dateOfBirthController.text),
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
                      context.read<FamilyTreeBloc>().add(AddPartnerNodeEvent(
                          node: node,
                          partnerNode: Person(
                              id: -1,
                              name: nameController.text,
                              gender: state.gender == Gender.female
                                  ? "F"
                                  : state.gender == Gender.male
                                      ? "M"
                                      : "O",
                              level: node.level,
                              relationData: [
                                RelationData(
                                    relatedUserId: node.id, relationTypeId: 0)
                              ])));
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

  void _showDatePicker(
      BuildContext context, bool isDateOfBirth, NodeDataLoaded state) async {
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
        context.read<NodeDataBloc>().add(
              ChangeData(
                gender: state.gender ?? Gender.male,
                name: state.name ?? "",
                dateOfDeath: !isDateOfBirth ? formattedDate : state.dateOfDeath,
                dateOfBirth: isDateOfBirth ? formattedDate : state.dateOfBirth,
              ),
            );
      }
    }
  }
}

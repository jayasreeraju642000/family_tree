import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddParents extends StatelessWidget {
  final Person node;
  const AddParents({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    context.read<FamilyTreeBloc>().add(FamilyTreeLoadingEvent());
    Person? father;
    Person? mother;
    return BlocConsumer<FamilyTreeBloc, FamilyTreeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FamilyTreeLoaded) {
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
                      _showAddNewItemDialog(context, state.nodes, true);
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
                          relationData: [
                            RelationData(
                                relatedUserId: node.id, relationTypeId: 1)
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
                      _showAddNewItemDialog(context, state.nodes, false);
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
                          relationData: [
                            RelationData(
                                relatedUserId: node.id, relationTypeId: 1)
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
      BuildContext context, List<Person> nodes, bool isFather) {
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
                      Person(
                          id: nodes.length + 1,
                          name: newItem,
                          gender: isFather ? "M" : "F",
                          level: node.level - 1,
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
    if (context.read<FamilyTreeBloc>().state is FamilyTreeLoaded) {
      if (!(context.read<FamilyTreeBloc>().state as FamilyTreeLoaded)
          .nodes
          .contains(newItem)) {
        context.read<FamilyTreeBloc>().add(AddFamilyNodeEvent(node: newItem));
        // Future.delayed(const Duration(microseconds: 50));
        // homePageKey.currentContext!
        //     .read<FamilyTreeBloc>()
        //     .add(AddFamilyNodeEvent(node: newItem));
      }
    }
  }
}

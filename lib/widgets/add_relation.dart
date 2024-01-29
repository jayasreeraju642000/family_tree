import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/widgets/add_parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';

class AddRelation extends StatelessWidget {
  final FamilyModel node;
  const AddRelation({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text("Add Relation")),
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
          ElevatedButton(
            onPressed: () {

               showDialog(
                context: context,
                builder: (context) => BlocProvider(
                    create: (context) => FamilyTreeBloc(),
                    child: AddParents(node: node)),
              );

            },
            child: const Text("Add Parents"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add Siblings"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add Partner"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Add Children"),
          )
        ],
      ),
    );
  }
}

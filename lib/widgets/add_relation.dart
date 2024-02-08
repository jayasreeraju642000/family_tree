import 'package:family_tree/bloc/family_tree/family_tree_bloc.dart';
import 'package:family_tree/bloc/node_data/node_data_bloc.dart';
import 'package:family_tree/widgets/add_childrens.dart';
import 'package:family_tree/widgets/add_parents.dart';
import 'package:family_tree/widgets/add_partner.dart';
import 'package:family_tree/widgets/add_siblings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/data/data.dart';

class AddRelation extends StatelessWidget {
  final Person node;
  const AddRelation({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
              child: Text(
            "Add Relation",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          )),
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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(
                    "Name: ${node.name}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),Text(
                    "Gender: ${node.gender == "M" ? "Male" : node.gender == "F" ? "Female" : "Others"}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Date of birth: ${node.dateOfBirth}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Date of death: ${node.dateOfBirth}",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                    const SizedBox(
                  height: 20,
                ),
                ],
              ),
            ],
          ),
          if (node.relationData
              .where((element) => element.relationTypeId == 1)
              .toList()
              .isEmpty) ...{
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
          },
          if (node.relationData
              .where((element) => element.relationTypeId == 1)
              .toList()
              .isNotEmpty) ...{
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider(
                      create: (context) => FamilyTreeBloc(),
                    ),
                    BlocProvider(
                      create: (context) => NodeDataBloc(),
                    )
                  ], child: AddSiblingView(node: node)),
                );
              },
              child: const Text("Add Siblings"),
            ),
            const SizedBox(
              height: 20,
            ),
          },
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => FamilyTreeBloc(),
                  ),
                  BlocProvider(
                    create: (context) => NodeDataBloc(),
                  )
                ], child: AddPartnerView(node: node)),
              );
            },
            child: const Text("Add Partner"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => FamilyTreeBloc(),
                  ),
                  BlocProvider(
                    create: (context) => NodeDataBloc(),
                  )
                ], child: AddChildView(node: node)),
              );
            },
            child: const Text("Add Children"),
          )
        ],
      ),
    );
  }
}

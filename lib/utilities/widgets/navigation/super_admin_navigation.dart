import 'package:afro_grids/screens/superAdmin/services/services_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:ionicons/ionicons.dart';

class SuperAdminNav extends StatefulWidget {
  const SuperAdminNav({Key? key}) : super(key: key);

  @override
  State<SuperAdminNav> createState() => _SuperAdminNavState();
}

class _SuperAdminNavState extends State<SuperAdminNav> {

  late final TreeViewController _treeViewController;

  @override
  void initState() {
    _treeViewController = TreeViewController(
        children: _children()
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView(
      controller: _treeViewController,
      onNodeTap: (key){
        Node selectedNode = _treeViewController.getNode(key)!;
        NavigationService.toPage(selectedNode.data);
      },
    );
  }

  List<Node> _children(){
    return [
      const Node(
          key: 'header',
          label: 'Super admin',
          icon: Icons.people,
          iconColor: Colours.primary,
          parent: true,
          children: [
            Node<Widget>(
              key: 'services',
              label: 'Services',
              icon: Ionicons.git_branch_outline,
              iconColor: Colours.primary,
              data: ServicesScreen(),
            )
          ]
      )
    ];
  }
}

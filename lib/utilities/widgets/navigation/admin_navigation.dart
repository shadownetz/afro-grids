import 'package:afro_grids/screens/admin/ads/ads_screen.dart';
import 'package:afro_grids/screens/superAdmin/services/services_screen.dart';
import 'package:afro_grids/utilities/colours.dart';
import 'package:afro_grids/utilities/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:ionicons/ionicons.dart';

import '../../../main.dart';
import '../../class_constants.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({Key? key}) : super(key: key);

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {

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
    List<Node> items = [];
    if( localStorage.user!.accessLevel == AccessLevel.superAdmin){
      items.addAll([superAdminNode(), adminNode()]);
    }
    else if(localStorage.user!.accessLevel == AccessLevel.admin){
      items.add(adminNode());
    }
    return items;
  }

  Node superAdminNode(){
    return const Node(
        key: 'super_admin_header',
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
    );
  }
  Node adminNode(){
    return const Node(
        key: 'admin_header',
        label: 'Admin',
        icon: Icons.people,
        iconColor: Colours.primary,
        parent: true,
        children: [
          Node<Widget>(
            key: 'Ads',
            label: 'Ads',
            icon: Ionicons.videocam,
            iconColor: Colours.primary,
            data: AdsScreen(),
          )
        ]
    );
  }

}

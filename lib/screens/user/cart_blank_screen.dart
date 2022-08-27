import 'package:flutter/material.dart';

import '../../utilities/colours.dart';

class CartBlankScreen extends StatelessWidget {
  final void Function() run;

  const CartBlankScreen({Key? key, required this.run}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    run();
    return Scaffold(
        backgroundColor: Colours.tertiary,
        appBar: AppBar(
          title: const Text("Checkout"),
        ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
      ),
    );
  }
}

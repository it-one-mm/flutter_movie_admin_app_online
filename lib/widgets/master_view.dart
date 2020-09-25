import 'package:flutter/material.dart';
import '../widgets/my_drawer.dart';

class MasterView extends StatelessWidget {
  MasterView({
    @required this.title,
    @required this.onCreate,
    this.child,
  });

  final String title;
  final Function onCreate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onCreate,
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: child,
    );
  }
}

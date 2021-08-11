import 'package:flutter/material.dart';
import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';

class ScreenFaq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JcphDrawer(),
      appBar: AppBar(
        title: Text("FAQs"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_rounded),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

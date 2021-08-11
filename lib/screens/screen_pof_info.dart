import 'package:flutter/material.dart';

class ScreenPofInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Proof of Payment'),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text('A proof of payment is a picture that shows a customer has paid.')
              ),
            ]

          ),
        ));
  }
}

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
          FlatButton.icon(
            label: Text('Cart'),
            icon: Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'scart');
            },
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: [
            QaPair(
              strQuestion: "Do you guys allow refunds?",
              strAnswer: "Unfortunately, we currently do not allow for refunds."
            ),
            QaPair(
                strQuestion: "Do you guys allow refunds?",
                strAnswer: "Unfortunately, we currently do not allow for refunds."
            ),
            QaPair(
                strQuestion: "Do you guys allow refunds?",
                strAnswer: "Unfortunately, we currently do not allow for refunds."
            ),
          ],
        ),
      ),
    );
  }
}

class QaPair extends StatelessWidget {
  const QaPair({
    Key key,
    this.question,
    this.answer,
    this.strQuestion,
    this.strAnswer,
  }) : super(key: key);

  final Widget question;
  final Widget answer;
  final String strQuestion;
  final String strAnswer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Padding(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          question ?? Text(strQuestion, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0,),
          answer?? Text(strAnswer),
        ],
      ), padding: EdgeInsets.all(10.0)),
    );
  }
}

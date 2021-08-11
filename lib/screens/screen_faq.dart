import 'package:flutter/material.dart';
import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';

class ScreenFaq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JcphDrawer(),
      appBar: AppBar(
        title: Text("FAQs")
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
                strQuestion: "How long is the delivery to Visayas/Mindanao?",
                strAnswer: "Deliveries bound outside of NCR will be carried out by LBC. As such, we will provide you with a tracking number that will allow you to track your order via LBC's website."
            ),
            QaPair(
                strQuestion: "I need various specifications for my order",
                strAnswer: "If ever you need a complex order that may involve bulk orders or custom designs and edits, feel free to send us an email and we'll reach out to you as soon as we can!"
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

import 'package:flutter_mailer/flutter_mailer.dart';

Future<MailerResponse> send(
    String _body,
    String _subject,
    List<String> _recipients,
    List<String> _attachments) async {
  // final mo = MailOptions(isHTML: true);
  return await (FlutterMailer.send(MailOptions(
      body: _body,
      subject: _subject,
      recipients: _recipients,
      attachments: _attachments
  )));
}
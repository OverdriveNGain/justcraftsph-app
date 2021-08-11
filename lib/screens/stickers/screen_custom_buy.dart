import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_order.dart';
import 'package:just_crafts_ph/classes/class_order_params.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/txt/prices.dart' as prices;
import 'package:just_crafts_ph/widgets/widget_add_to_cart.dart';
import 'package:just_crafts_ph/classes/class_smaterial.dart';
import 'package:file_picker/file_picker.dart' as filePicker;
import 'package:flutter_form_builder/flutter_form_builder.dart';

// todo: setup a privacy policy

class ScreenCustomBuy extends StatefulWidget {
  @override
  _ScreenCustomBuyState createState() => _ScreenCustomBuyState();
}

class _ScreenCustomBuyState extends State<ScreenCustomBuy> {
  Smaterial _smaterial;
  TextEditingController _pageCountController = TextEditingController();
  TextEditingController _linksController = TextEditingController();
  TextEditingController _instructions = TextEditingController();
  TextEditingController _email = TextEditingController();
  int _pageCountNumber = 0;
  int _uploadChoice = 0;
  String _downloadLinks = '';
  List<File> _files = [];
  final _formKey = GlobalKey<FormState>();
  final _radioButtons = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_smaterial == null)
      _smaterial = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          // todo: change this
          title: Text('Custom Stickers'),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What\'s your material?',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Divider(),
                            _smaterial.toMaterialTile(false, null),
                            SizedBox(
                              width: double.maxFinite,
                              child: RaisedButton(
                                onPressed: () async {
                              final smat = await showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height:8.0),
                                        Text('Choose a material'),
                                        SizedBox(height:8.0)
                                      ] +  prices.smaterials
                                          .map((e) => e.toMaterialTile(true,
                                                    () async {
                                                    Navigator.pop(context, e);
                                              }))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              );
                              if (smat != null)
                                setState(() {
                                  _smaterial = smat;
                                });

                                },
                                child: Text('Change'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'How many pages?',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Divider(),
                            Row(children: [
                              SizedBox(width: 5.0),
                              Expanded(
                                  child: TextFormField(
                                controller: _pageCountController,
                                validator: (s) => (int.tryParse(s) ?? 0) > 0
                                    ? null
                                    : 'Please enter a valid number.',
                                keyboardType: TextInputType.number,
                                onEditingComplete: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                },
                              ))
                            ]),
                            SizedBox(height:10.0),
                            Text('*Bulk price are for custom orders of ${prices.customBulkCountMinimum} sheets or more.',
                              style: TextStyle(
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 4.0,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How can we get your sticker files?',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Divider(),
                                FormBuilderRadioGroup(
                                  key: _radioButtons,
                                  validator: (n) {
                                    print('n is $n');
                                    switch(n){
                                      case 1:
                                        return (_files.length == 0?'Please upload at least one file': null);
                                      case 2:
                                        return null;
                                      case 3:
                                        return null;
                                      default:
                                        return 'Please select an option';
                                    }
                                  },
                                  name: null,
                                  onChanged: (n) {
                                    setState(() {
                                      _uploadChoice = n;
                                    });
                                  },
                                  options: [
                                    FormBuilderFieldOption(
                                      value: 1,
                                      child: Text(
                                          'I\'ll upload them here'
                                      ),
                                    ),
                                    FormBuilderFieldOption(
                                      value: 2,
                                      child: Text(
                                          'I have my download link/s'
                                      ),
                                    ),
                                    FormBuilderFieldOption(
                                      value:3,
                                      child: Text(
                                          'I\'ll send an email'
                                      ),
                                    ),
                                  ]
                                ),
                                SizedBox(height: 10.0),
                                fileOption(_uploadChoice),
                                SizedBox(height: 10.0),
                                Text(
                                  '*Files can be in any of the following formats: PDF, DOCS, ZIP, RAR, 7z, PNG, JPG, PSD, AI',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                  ),
                                ),
                              ])),
                    ),
                    SizedBox(height: 10.0),
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 4.0,
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Do you have additional instructions? (optional)',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  '*Customer will be contacted via email/phone for missing specifications',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                  ),
                                ),
                              ])),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      height: 50.0,
                      width: double.maxFinite,
                      child: AddToCart(func: () {
                        if (!_formKey.currentState.validate()) return;
                        FileManager.st.addOrder(CustomOrder()
                          ..initFromParams(CustomOrderParams(
                              filePaths: _files.map((e) => e.path).toList(),
                              downloadLinks: _downloadLinks,
                              pageCount:
                                  int.tryParse(_pageCountController.text),
                              instructions: _instructions.text,
                              smaterial: _smaterial,
                              email: _email.text,
                              )));
                        Fluttertoast.showToast(
                            msg: "Item added to cart!",
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIosWeb: 1,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  bool testing() {
    print('testing');
    print(_pageCountNumber);
    print(_pageCountNumber > 0);
    print(_uploadChoice != 0);
    print(_uploadChoice == 1
        ? _files.isNotEmpty
        : _downloadLinks.trim().isNotEmpty);
    print('done testing');
    return (_pageCountNumber > 0 &&
        _uploadChoice != 0 &&
        (_uploadChoice == 1
            ? _files.isNotEmpty
            : _downloadLinks.trim().isNotEmpty));
  }

  Widget fileOption(int _choice) {
    if (_uploadChoice == 0) return Center();

    if (_uploadChoice == 1) {
      //upload here

      Widget selectFilesButton = SizedBox(
          width: double.maxFinite,
          child: RaisedButton(
            // todo: implement this color all over the app
            color: Colors.brown[600], //Theme.of(context).buttonColor,
            child: Text(
              'Add files',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              final result = await filePicker.FilePicker.platform
                  .pickFiles(allowMultiple: true);
              if (result != null) {
                setState(() {
                  _files.addAll(result.files.map((e) => File(e.path)));
                });
              }
            },
          ));
      if (_files.isEmpty) return selectFilesButton;
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[] +
              (_files.map((e) => (Container(
                  child: Row(
                    children: [
                      SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: [
                            'jpg',
                            'jpeg',
                            'png',
                            'bmp'
                          ].contains(e.path.split('.').last.toLowerCase())
                              ? Image.asset(e.path)
                              : Icon(Icons.insert_drive_file)),
                      SizedBox(width: 10.0),
                      Expanded(child: Text(e.path.split('/').last)),
                      SizedBox(width: 10.0),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _files.remove(e);
                            });
                          })
                    ],
                  ),
                  color: Colors.grey[200],
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                  padding: const EdgeInsets.all(10.0))))).toList() +
              [selectFilesButton]);
    }

    if (_uploadChoice == 2) {
      //download links
      return TextFormField(
        //todo: check if download link more properly
        validator: (s) => (s.contains('.') && s.contains('/'))
            ? null
            : 'Please enter valid download links',
        decoration: InputDecoration(hintText: 'Enter download links per line'),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _linksController,
        onChanged: (e) {
          setState(() {
            _downloadLinks = _linksController.text;
          });
        },
      );
    }

    if (_uploadChoice == 3) {
      //download links
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• Please enter your name as the subject line'),
          Divider(),
          TextFormField(
            validator: (s) => (s.contains('@') && s.contains('.'))
                ? null
                : 'Please enter a valid email.',
            decoration: InputDecoration(hintText: 'example@email.com'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _email,
            onChanged: (e) {
              setState(() {
                _downloadLinks = _linksController.text;
              });
            },
          ),
        ],
      );
    }

    throw Exception('Invalid choice for fileOption: $_choice');
  }
}

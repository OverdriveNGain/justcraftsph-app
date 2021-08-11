import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';

class ScreenNewAddress extends StatefulWidget {
  @override
  _ScreenNewAddressState createState() => _ScreenNewAddressState();
}

class _ScreenNewAddressState extends State<ScreenNewAddress> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _tempName = TextEditingController();
  TextEditingController _tempPhone = TextEditingController();
  Region _tempRegion;
  TextEditingController _tempAddress = TextEditingController();
  TextEditingController _tempInstructions = TextEditingController();
  TextEditingController _tempEmail= TextEditingController();
  bool _interactable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Address'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (!_interactable)?null: (){
            Navigator.pop(context);
          }
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: Text('All data are stored locally.',
                          textAlign: TextAlign.center),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width:10.0),
                      Expanded(
                          child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  )
                              ),
                            controller: _tempName,
                            validator: (s) {
                                if (s.isEmpty)
                                  return "Please enter valid name";
                                return null;
                            },
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.phone_enabled),
                      SizedBox(width:10.0),
                      Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  )
                              ),
                            controller: _tempPhone,
                            validator: (s){
                                if (s.length != 0 && s[0] == '+'){
                                  if (s.length != 13)
                                    return 'Please enter a valid phone number';
                                }
                                else if (s.length < 10 || s.length > 12){
                                    return 'Please enter a valid phone number';
                                }
                                return null;
                            },
                          )
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.map),
                      SizedBox(width:10.0),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: Offset(0, 10.0),
                                child: Text("Region",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey,
                                    )),
                              ),
                              DropdownButtonFormField( // todo: add option for same day delivery
                                value: _tempRegion,
                                validator: (s) {
                                  if (s == null)
                                    return "Please select a region";
                                  return null;
                                },
                                items: <DropdownMenuItem<Region>>[DropdownMenuItem(
                                    child: Text(''),
                                )] + Region.values.map((e) => DropdownMenuItem(
                                    child: Text(Address.displayStringFromRegion(e)),
                                  value: e,
                                )).toList(),
                                onChanged: (n) {
                                  setState((){ _tempRegion = n;});
                                },
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.pin_drop),
                      SizedBox(width:10.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Shipping Address',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )
                          ),
                          controller: _tempAddress,
                          validator: (s) {
                            if (s.isEmpty)
                              return 'Please enter a valid address';
                            return null;
                          },
                          maxLines: null,
                        )
                    )
                  ],
                ),
                  Row(
                    children: [
                      Icon(Icons.drive_eta),
                      SizedBox(width:10.0),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Instructions for Delivery Driver (Optional)',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )
                          ),
                          controller: _tempInstructions,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.alternate_email),
                      SizedBox(width:10.0),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email (Optional)',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          )
                        ),
                        controller: _tempEmail,
                      )
                    )
                    ],
                  ),
                  SizedBox(height:10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary),
                    onPressed: (!_interactable)?null:
                      () async{
                        setState((){_interactable = false;});
                        if (_formKey.currentState.validate()){
                          Address _address = Address(
                            name: _tempName.text,
                            email: _tempEmail.text,
                            number: _tempPhone.text,
                            region: _tempRegion,
                            address: _tempAddress.text,
                            deliveryInstructions: _tempInstructions.text,
                            unix: DateTime.now().millisecondsSinceEpoch.toString()
                          );
                          if (await FileManager.st.addAddress(_address)){
                            Fluttertoast.showToast(
                                msg: "Successfully saved new address!",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 1,
                                textColor: Theme.of(context).colorScheme.onSurface,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                fontSize: 16.0
                            );
                            Navigator.pop(context);
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: "Error saving address.",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 1,
                                textColor: Theme.of(context).colorScheme.onSurface,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                fontSize: 16.0
                            );
                            setState((){_interactable = false;});
                          }
                        }
                        else
                          setState((){_interactable = true;});
                      },
                    child: Text("Submit", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_crafts_ph/classes/class_address.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';

class ScreenPickAddress extends StatefulWidget {
  @override
  _ScreenPickAddressState createState() => _ScreenPickAddressState();
}

class _ScreenPickAddressState extends State<ScreenPickAddress> {
  TextStyle _infoDataStyle = TextStyle(fontSize: 14.0);
  int _loadstate = 0;
  List<Address> addresses;
  Address _currentSelected;

  @override
  void initState(){
    super.initState();
    myInit(true);
  }

  @override
  Widget build(BuildContext context) {
    _currentSelected = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick Address'
        ),
      ),
      body: getAddressList(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add new address",
        onPressed: () async {
          await Navigator.pushNamed(context, 'newaddress');
          await myInit(true);
        },
      ),
    );
  }

  Container getAddressList(BuildContext context) {
    if (_loadstate == 0){
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Align(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Loading addresses...'),
          ),
          alignment: Alignment.topCenter,
        ),
      );
    }
    if (_loadstate == -1 || (_loadstate == 1 && addresses.length == 0)){
      return Container(
        color: Theme.of(context).colorScheme.background,
        child: Align(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text('Press (+) to add a new address!'),
          ),
          alignment: Alignment.topCenter,
        ),
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.background,
        child: ListView(
          children:
            addresses.map((e) => Container(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 5.0,
                color: Colors.white,
                child: Ink(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: (){
                      Navigator.pop(context, e);
                    },
                    child: toAddressTile(e),
                  ),
                ),
              ),
            )).toList(),
        ),
      );
  }

  Container toAddressTile(Address e) {
    if (_currentSelected != null){}
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0,20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: insertAtAll([
                _currentSelected == e ? Text("✓ Selected", style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold,
                )): Center(),
                Opacity(
                    opacity:0.3,
                    child: Text('Name:')
                ),
                Text(e.name, style: _infoDataStyle),
                Opacity(
                    opacity:0.3,
                    child: Text('Address:')
                ),
                Text(e.address, style: _infoDataStyle),
                Opacity(
                    opacity:0.3,
                    child: Text('Number:')
                ),
                Text(e.number, style: _infoDataStyle),
                Opacity(
                  opacity:0.3,
                  child: Text('Region:'),
                ),
                Text(Address.displayStringFromRegion(e.region) , style: _infoDataStyle),
              ] + (e.deliveryInstructions.trim()==''?[]:[
                Opacity(
                  opacity:0.3,
                  child: Text('Additional Delivery Instructions:'),
                ),
                Text(e.deliveryInstructions , style: _infoDataStyle),
              ]) + (e.email.trim()==''?[]:[
                Opacity(
                  opacity:0.3,
                  child: Text('Email to Send Receipt:'),
                ),
                Text(e.email , style: _infoDataStyle),
              ]), SizedBox(height:5.0), false),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Edit")),
              PopupMenuItem(child: Text("Delete"))
            ],
          )
        ],
      ),
    );
  }

  Future<void> myInit(bool rebuild) async{
    bool success = await FileManager.st.loadAddresses();
    _loadstate = success?1:-1;
    addresses = FileManager.st.addresses;
    setState(() { });
  }

  List<T> insertAtAll<T>(List<T> list, T toInsert, bool insertAtEnd){
    return List<T>.generate(list.length * 2 - (insertAtEnd?0:1), (index) => index % 2 == 1? toInsert: list[index ~/ 2]);
  }
}

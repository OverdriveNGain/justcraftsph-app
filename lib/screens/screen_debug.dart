import 'package:flutter/material.dart';
import 'package:just_crafts_ph/shared/shared_file_manager.dart';
import 'package:just_crafts_ph/widgets/widget_jcph_drawer.dart';
import 'package:just_crafts_ph/shared/shared_io_helper.dart';
import 'package:just_crafts_ph/shared/shared_funcs.dart' as funcs;
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cachem;

class ScreenDebug extends StatefulWidget {
  @override
  _ScreenDebugState createState() => _ScreenDebugState();
}

class _ScreenDebugState extends State<ScreenDebug> {
  String debugText = "Hello world!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: JcphDrawer(),
      appBar: AppBar(
        title: Text("Debug"),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Print directories"),
                    onPressed: () async {
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null)
                        debugText = dirs;
                      else
                        debugText = "Cannot print directories";
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Move Down"),
                    onPressed: () async {
                      await IoHelper.debugMoveSelect(-1);
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null)
                        debugText = dirs;
                      else
                        debugText = "Cannot print directories";
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Move Up"),
                    onPressed: () async {
                      await IoHelper.debugMoveSelect(1);
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null)
                        debugText = dirs;
                      else
                        debugText = "Cannot print directories";
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Out Directory"),
                    onPressed: () async {
                      await IoHelper.debugDirectoryDirection(-1);
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null)
                        debugText = dirs;
                      else
                        debugText = "Cannot print directories";
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("In Directory"),
                    onPressed: () async {
                      await IoHelper.debugDirectoryDirection(1);
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null)
                        debugText = dirs;
                      else
                        debugText = "Cannot print directories";
                      setState(() {});
                    },
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Delete Selected"),
                    onPressed: () async {
                      final success = await IoHelper.debugDeleteSelected();
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null && success == true)
                        debugText = dirs;
                      else{
                        if (!success)
                          debugText = "Cannot delete file/directory";
                        else
                          debugText = "Cannot print directories";
                      }
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Init Folders"),
                    onPressed: () async {
                      final success = await FileManager.st.initFolders();
                      String dirs = await IoHelper.printFileList();
                      if (dirs != null && success == true){
                        debugText = dirs;
                        print('success');
                      }
                      else{
                        if (!success)
                          debugText = "Cannot init folders";
                        else
                          debugText = "Cannot print directories";
                      }
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Timestamp"),
                    onPressed: () async {
                      final stamp = funcs.timeStamp();
                      setState(() {
                        debugText = stamp;
                      });
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Open Selected"),
                    onPressed: () async {
                      try{
                        debugText = await IoHelper.debugOpenSelectedAsString();
                      }
                      catch(e){
                        debugText = 'Cannot open selected string.';
                        print(e);
                      }
                      setState(() {});
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary:Colors.white),
                    child:Text("Clear Caches"),
                    onPressed: () async {
                      try{
                        await cachem.DefaultCacheManager().emptyCache();
                        debugText = 'Successfully cleared caches.';
                      }
                      catch(e){
                        debugText = 'Cannot clear caches.';
                        print(e);
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Text(
                      debugText
                    ),
                  ),
              ),
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

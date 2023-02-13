import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home_Page extends StatefulWidget {
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  Box? notepad;
  @override
  void initState() {
    notepad = Hive.box('authBox');
    super.initState();
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _updateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Example Local DataBase Hive")),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'write something'),
            ),
            SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () async {
                    try {
                      final userInput = _controller.text;
                      await notepad!.add(userInput);
                      Fluttertoast.showToast(msg: "added successfully");
                      _controller.clear();
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: Text(
                    'add new data',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: notepad!.keys.toList().length,
                  itemBuilder: (_, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(notepad!.getAt(index).toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return Dialog(
                                            child: Container(
                                              height: 200,
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _updateController,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              'write something'),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          final updateData =
                                                              _updateController
                                                                  .text;
                                                          notepad!.putAt(index,
                                                              updateData);
                                                          _updateController
                                                              .clear();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "updated successfully");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Update"))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    try {
                                      await notepad!.deleteAt(index);
                                      Fluttertoast.showToast(
                                          msg: "Deleted successfully");
                                    } catch (e) {}
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

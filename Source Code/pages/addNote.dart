import 'package:flutter/material.dart';
import 'package:notely/database/dbHelper.dart';
import 'package:notely/models/notes.dart';

class AddNote extends StatefulWidget {
  final Note note;
  final String appTitle;
  AddNote({Key key, this.note, this.appTitle}) : super(key: key);

  _AddNoteState createState() => _AddNoteState(this.note, this.appTitle);
}

class _AddNoteState extends State<AddNote> {
  //Variables
  DBHelper dbHelper = DBHelper();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();

  Note note;
  String appTitle;
  num txtColor;
  String btnTxt;
  _AddNoteState(this.note, this.appTitle);

  void initState() {
    super.initState();
    btnTxt = note.id == null ? "Add Notely" : "Save Notely";
  }

  @override
  Widget build(BuildContext context) {
    _title.text = note.title;
    _body.text = note.body;
    txtColor = note.color == null ? 0xffffffff : note.color;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          appTitle,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w300, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff2680EB),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                child: Text(btnTxt,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _save();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                child: Text("Delete Notely",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _delete();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(25),
                child: TextField(
                  controller: _title,
                  onChanged: (val) {
                    updateTite();
                  },
                  style:
                      TextStyle(color: Color(note.color), letterSpacing: 1.5),
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: "Title",
                      hintStyle:
                          TextStyle(color: Color(note.color), fontSize: 25),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Set Text Color",
                      style: TextStyle(fontSize: 22, color: Color(txtColor)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //First
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: FlatButton(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xff1578E8),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            setColor(0xff1578E8);
                          },
                        ),
                      ),
                      //Second
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: FlatButton(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xffFF0053),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            setColor(0xffFF0053);
                          },
                        ),
                      ),
                      //third
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: FlatButton(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xffFFE748),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            setColor(0xffFFE748);
                          },
                        ),
                      ),
                      //forth
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: FlatButton(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(0xff4FCC20),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            setColor(0xff4FCC20);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: TextField(
                  controller: _body,
                  maxLines: 12,
                  onChanged: (val) {
                    updateBody();
                  },
                  style:
                      TextStyle(color: Color(note.color), letterSpacing: 1.5),
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: "Body",
                      hintStyle:
                          TextStyle(color: Color(note.color), fontSize: 25),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void updateTite() {
    note.title = _title.text;
  }

  void updateBody() {
    note.body = _body.text;
  }

  void setColor(num color) {
    setState(() {
      txtColor = color;
      note.color = txtColor;
      txtColor = note.color;
    });
  }

  void _save() async {
    int result; //variable for db error checking
    //Todo: Implement error Checking

    if (note.id != null) {
      //Updates Note
      result = await dbHelper.update(note);
    } else {
      //inserts Note
      result = await dbHelper.insert(note);
    }
  }

  void _delete() async {
    if (note.id == null) {
      return;
    }

    int result = await dbHelper.delete(note.id);
  }
}

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
  IconData btnIcon;
  String btnTxt;
  _AddNoteState(this.note, this.appTitle);
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    btnTxt = note.id == null ? "Add Notely" : "Save Notely";
    btnIcon = note.id == null ? Icons.add : Icons.save_alt;
  }

  @override
  Widget build(BuildContext context) {
    _title.text = note.title;
    _body.text = note.body;
    txtColor = note.color == null ? 0xffffffff : note.color;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      key: _key,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  icon: Icon(btnIcon),
                  label: Text(
                    btnTxt,
                    style: TextStyle(fontSize: 22),
                  ),
                  heroTag: null,
                  backgroundColor: Color(0xff1578E8),
                  onPressed: () {
                    setState(() {
                      _save();
                    });
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton.extended(
                  icon: Icon(Icons.delete_outline),
                  label: Text(
                    "Delete Notely",
                    style: TextStyle(fontSize: 22),
                  ),
                  heroTag: null,
                  backgroundColor: Color(0xffFF0053),
                  onPressed: () {
                    setState(() {
                      _delete();
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            )
          : null,
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
                      FlatButton(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xff1578E8),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          setColor(0xff1578E8);
                        },
                      ),
                      //Second
                      FlatButton(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xffFF0053),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          setColor(0xffFF0053);
                        },
                      ),
                      //third
                      FlatButton(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xffFFE748),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          setColor(0xffFFE748);
                        },
                      ),
                      //forth
                      FlatButton(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          setColor(0xffffffff);
                        },
                      ),
                    ],
                  ),
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
    if(result != 0){
      showBar("Notely Added", Colors.blue);
    }
    showBar("Error While Adding Note \n Please make sure you added title and body properly", Colors.red);
  }

  void _delete() async {
    if (note.id == null) {
      return;
    }

    int result = await dbHelper.delete(note.id);
    if(result != 0){
      showBar("Notely Deleted", Colors.red);
    }
    showBar("Error while deleting Notely", Colors.red);
  }

  void showBar(String txt, Color color){
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: color,
    );
    _key.currentState.showSnackBar(snackBar);
  }
}

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
  _AddNoteState(this.note, this.appTitle);

  @override
  Widget build(BuildContext context) {
    _title.text = note.title;
    _body.text = note.body;

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
                child: Text("Add Notely",
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
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: TextField(
                controller: _title,
                
                onChanged: (val){updateTite();},
                style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 25),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: TextField(
                controller: _body,
                maxLines: 12,
                
                onChanged: (val){updateBody();},
                style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    hintText: "Body",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 25),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void updateTite(){
    note.title = _title.text;
  }
  void updateBody(){
    note.body = _body.text;
  }

  void _save() async{
    int result; //variable for db error checking
    //Todo: Implement error Checking

    if(note.id != null){ //Updates Note
      result = await dbHelper.update(note);
    }else{//inserts Note
      result = await dbHelper.insert(note);
    }
  }

  void _delete() async{
    if(note.id == null){
      return;
    }

    int result = await dbHelper.delete(note.id);
  }
}

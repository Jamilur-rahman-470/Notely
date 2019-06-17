import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notely/database/dbHelper.dart';
import 'package:notely/models/notes.dart';
import 'package:notely/pages/addNote.dart';
import 'package:sqflite/sqflite.dart';

class Notes extends StatefulWidget {
  Notes({Key key}) : super(key: key);

  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  DBHelper dbHelper = DBHelper();
  List<Note> noteList;
  num color = 0xffffffff;

  int c = 0;
  void dispose() {
    super.dispose();
    dbHelper.closeDB();
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateView();
    }
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          "Notely",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(
          "Add Notely",
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Color(0xff1578E8),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNote(
                        note: Note("", "", color),
                        appTitle: "ADD Notely",
                      )));
        },
      ),
      body: FutureBuilder(
        future: dbHelper.getNoteList(),
        builder: (BuildContext context, AsyncSnapshot shot) {
          if (shot.hasData) {
            noteList = shot.data;
            c = noteList.length;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: c,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Card(
                    color: Color(0xff2D2D2D),
                    elevation: 3,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          this.noteList[index].title,
                          style: TextStyle(
                              color: Color(this.noteList[index].color),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Text(
                          this.noteList[index].body,
                          style: TextStyle(
                              color: Color(this.noteList[index].color),
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_sweep,
                          size: 30,
                          color: Color(0xffF3223F),
                        ),
                        onPressed: () {
                          _delete(context, noteList[index]);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNote(
                                      note: this.noteList[index],
                                      appTitle: "EDIT Notely",
                                    )));
                      },
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("No Note Added",
                    style: TextStyle(color: Colors.black45, fontSize: 26))
              ],
            ),
          );
        },
      ),
    );
  }

  //Update View
  void updateView() {
    final Future<Database> db = dbHelper.initDB();
    db.then((database) {
      Future<List<Note>> noteF = dbHelper.getNoteList();
      noteF.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.c = noteList.length;
        });
      });
    });
  }


  void showBar(String txt, Color color){
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: color,
    );
    _key.currentState.showSnackBar(snackBar);
  }


  void _delete(BuildContext context, Note note) async {
    int result = await dbHelper.delete(note.id);
    updateView();
    if(result != 0){
      showBar("Notely Deleted", Colors.red);
    }
  }
}

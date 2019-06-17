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
  void dispose(){
    super.dispose();
    dbHelper.closeDB();
  }
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notely",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Color(0xff2680EB),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                child: Text(
                  "Add Note",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNote(
                                note: Note(
                                  "",
                                  "",
                                  color
                                ),
                                appTitle: "ADD Notely",
                              )));
                },
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: dbHelper.getNoteList(),
        builder: (BuildContext context, AsyncSnapshot shot) {
          if (shot.hasData) {
            noteList = shot.data;
            c = noteList.length;
            return Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 385,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Color(0xff2680EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 90, left: 30),
                          child: Text("Hi", style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: Text("Notes" , style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(c.toString() , style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w400),),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: c,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
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
                  ),
                ],
              ),
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

  void _delete(BuildContext context, Note note) async {
    int result = await dbHelper.delete(note.id);
    updateView();
  }
}

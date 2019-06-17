
import 'dart:ui';

class Note{
  int _id;
  String _title;
  String _body;
  num _color;

  Note(this._title, this._body, this._color);

  //Getter 
  int get id => _id;
  String get title => _title;
  String get body => _body;
  num get color => _color;
 
  //Setter
  set title(String newT) => this._title = newT;
  set body(String newB) => this._body = newB;
  set color(num newC) => this._color = newC;
  


  Map<String, dynamic> toDB(){
    var map = Map<String, dynamic>();

    if(id != null){
      map['id'] = id;
    }
    map['title'] = _title;
    map['body'] = _body;
    map['color'] = _color;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._body = map['body'];
    this._color = map['color'];
  }
}
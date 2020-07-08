import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

final Map _gifData;
  //declarando no contrutor
GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        //Ação para Appbar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              //utilizando plugins share: "^0.5.2"
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"])
      ),


    );
  }
}

import 'dart:convert';

import 'package:buscadorgifs/ui/gif_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  //para adicionar páginação nos gifs
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    //há dois tipos de respostas, as pesquisadas e as principais

    //retorna os gifs mais interessantes
    if (_search == null || _search.isEmpty)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=OCTHImaaEpMWd9yM0TX6sEfwE1BN15OT&limit=20&rating=G");
    else

      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=OCTHImaaEpMWd9yM0TX6sEfwE1BN15OT&q=$_search&limit=19&offset=$_offset&rating=G&lang=pt");


    return json.decode(response.body);
  }
//atualiza tela
  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  //layout da tela

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //cor da AppBar
        backgroundColor: Colors.black,
        //titulo da appbar
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        //centralizando titulo
        centerTitle: true,
      ),
      //corpo do app
      //cor do corpo
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  //borda no campo
                  border: OutlineInputBorder()),
              //estilo do texto dentro do campo
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          //para ocupar  o espaço restante
          Expanded(
            //
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          //largura
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }
int _getCount(List data){
  if(_search == null || _search.isEmpty){
      return data.length;
    }else{
      return data.length +1;
    }
}
  //função
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        //mostra como os icones serão organizados
        //tipo de grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        //wigget que ficará em cada posição
        itemBuilder: (context, index) {
          if(_search == null || index < snapshot.data["data"].length)
            //GestureDetector serve para disponibilizar o click na imagem
            return GestureDetector(
              //exibir imagens com efeito de aparecimento
              child:FadeInImage.memoryNetwork(
                  //imagem transparente adicionando plugin transparent_image: "^0.1.0"
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover ,
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color:Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset+=19;
                  });
                },
              ),
            );



        });
  }
}

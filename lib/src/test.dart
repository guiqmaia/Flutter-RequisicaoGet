import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({required this.userId, required this.id,required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }

}

Future<Post> pegarPost() async{

  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if(response.statusCode == 200){
    return Post.fromJson(json.decode(response.body));
  }else{
    throw Exception('Falhou na requisição do Post');
  }

}


class TestPage extends StatefulWidget {
  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {

  late Future<Post> postagem;

  @override
  void initState(){
    super.initState();

    postagem = pegarPost();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Teste'),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: postagem,
          builder: (context, snapshot){
              if(snapshot.hasData){
                return Text(snapshot.data!.body);
              }else if(snapshot.hasError){
                return const Text('snapshot.error');
              }else{
                return CircularProgressIndicator();
              }
          },
        ),
      )
    );
  }
}

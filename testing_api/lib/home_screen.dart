import 'dart:convert';

import 'package:flutter/material.dart';
import 'Models/posts_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Posts> postsModel = [];

  Future<List<Posts>> getPostsData() async {
    
    http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){

      postsModel.clear();
      print(data);
      for(Map i in data){
        postsModel.add(Posts.fromJson(i));
      }
      return postsModel;
    }

    return postsModel;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tesing-API'),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: getPostsData(),
        builder: (context,AsyncSnapshot<List<Posts>> snapshot){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          else{
            return ListView.builder(
                itemCount: postsModel.length,
                itemBuilder: (context,index){
                  return Text(snapshot.data![index].title.toString());
                }
            );
          }
        }
      )
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/photos_model.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  List<Photos> photos = [];

  Future<List<Photos>> getPhotos() async {
    
    http.Response response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

    var data = jsonDecode(response.body.toString());

    if(response.statusCode == 200){

      photos.clear();

      for(Map i in data){
        photos.add(Photos(albumId: i['albumId'], id: i['id'], title: i['title'], url: i['url']));
      }

      return photos;
    }

    else{
      return photos;
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPhotos(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          else{
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data![index].url ?? '')
                    ),
                    title: Text(snapshot.data![index].title ?? ''),
                    subtitle: Text(snapshot.data![index].albumId.toString()),
                    trailing: Text(snapshot.data![index].id.toString()),
                  );
                }
            );
          }
        }
      ),
    );
  }
}

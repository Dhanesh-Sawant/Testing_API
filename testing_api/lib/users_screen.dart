import 'dart:convert';
import 'package:flutter/material.dart';
import 'Models/Users/Users_model.dart';
import 'package:http/http.dart' as http;

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  
  List<UsersModel> userdata = [];
  
  
  Future<List<UsersModel>> getUserData() async {
    
   http.Response response = await  http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

   var data = jsonDecode(response.body.toString());

   if(response.statusCode == 200){

     userdata.clear();

     for(Map i in data){
        userdata.add(
            UsersModel.fromJson(i)
        );
     }
   }
  
   return userdata;

  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Users Details'),
      ),
      
      body: FutureBuilder(

        future: getUserData(),
        builder: (
            context,
            AsyncSnapshot<List<UsersModel>> snapshot
            ){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          else
          {
            return ListView.builder(
              shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,

                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('ID: '),
                              Text(snapshot.data![index].id.toString())
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('NAME: '),
                              Text(snapshot.data![index].name.toString())
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('USERNAME: '),
                              Text(snapshot.data![index].username.toString())
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('EMAIL: '),
                              Text(snapshot.data![index].email.toString())
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('ADDRESS: '),
                              Text(
                                  snapshot.data![index].address?.street ?? ""
                              ),
                              Text(
                                  snapshot.data![index].address?.suite ?? ""
                              ),
                              Text(
                                  snapshot.data![index].address?.city ?? ""
                              ),
                              Text(
                                  snapshot.data![index].address?.zipcode ?? ""
                              ),
                              Text(
                                  snapshot.data![index].address?.geo?.lat ?? ""
                              ),
                              Text(
                                  snapshot.data![index].address?.geo?.lng ?? ""
                              )
                            ],
                          ),

                        ],

                      ),
                    ),
                  );

                }
            );

          }
        },
      ),
      
    );
  }
}




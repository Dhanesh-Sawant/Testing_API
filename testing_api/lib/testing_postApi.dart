import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostReq extends StatefulWidget {
  const PostReq({Key? key}) : super(key: key);

  @override
  State<PostReq> createState() => _PostReqState();
}

class _PostReqState extends State<PostReq> {

  late TextEditingController _nameController;
  late TextEditingController _jobController;
  
  String? result;
  bool _isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _jobController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _jobController.dispose();
  }

  Future<void> postData(String name, String job) async {

    try{
      http.Response response = await http.post(
          Uri.parse('https://reqres.in/api/users'),
          headers: {
            "name" : name,
            "job" : job
          }
      );

      if(response.statusCode == 201){

        setState(() {
          result = response.body;
        });


      }
      else{
        print("status code not 201");
      }


    }catch(e){
      print(e);
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text('Sign Up', style: TextStyle(
                fontSize: 35
              ),),

              SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name'
                ),
              ),

              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(
                    hintText: 'Enter your job title'
                ),
              ),

              const SizedBox(height: 32),

              MaterialButton(
                color: Colors.blue,
                child: const Text('Submit'),
                  onPressed: ()async{

                  setState(() {
                      _isloading = true;
                  });

                  await postData(_nameController.text,_jobController.text);

                  setState(() {
                    _isloading = false;
                  });
                  }
              ),
              const SizedBox(height: 32),
              Container(
                child: !_isloading ? Text(result ?? "") : CircularProgressIndicator(color: Colors.blue,)
              )
            ],
          ),
        ),
      ),

    );
  }
}

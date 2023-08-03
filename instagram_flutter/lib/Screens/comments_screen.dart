import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Resources/firestore_methods.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:provider/provider.dart';
import '../Models/Users.dart';
import '../Providers/user_provider.dart';
import '../Utils/comment_card.dart';

class CommentScreen extends StatefulWidget {

  final snap;

  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comment..'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Posts').doc(widget.snap['PostId']).collection('comments').orderBy('datePublished',descending: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length, // or we can do as same as post
              itemBuilder: (context,index) => CommentCard(
                snap : snapshot.data!.docs[index].data()
              ));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.picUrl,
                ),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'comment as ${user.username}',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  await FireStoreMethods().postComment(
                      widget.snap['PostId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.picUrl
                  );
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Post',style: TextStyle(color: Colors.blueAccent),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

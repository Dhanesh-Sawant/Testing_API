import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Resources/firestore_methods.dart';
import 'package:instagram_flutter/Screens/login_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Utils/utils.dart';

import '../Resources/auth_methods.dart';
import '../Widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {

  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};
  int postlen = 0;
  int followerscount = 0;
  int followingcount = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{

    setState(() {
      isLoading = true;
    });

    try{
      var UserSnap = await FirebaseFirestore.instance.collection('Users').doc(widget.uid).get();

      // get post length

      var PostSnap = await FirebaseFirestore.instance.collection('Posts').where('uid',isEqualTo: widget.uid).get();

      postlen = PostSnap.docs.length;
      userData = UserSnap.data()!;

      followerscount = UserSnap.data()!['followers'].length;
      followingcount = UserSnap.data()!['following'].length;

      isFollowing = UserSnap.data()!['following'].contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {

      });

    }
    catch(e){
      showSnackBar(e.toString(), context);
    }

    setState(() {
      isLoading = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(userData['username']),
          centerTitle: false,
        ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['picUrl']
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(postlen, "posts"),
                            buildStatColumn(followerscount, "followers"),
                            buildStatColumn(followingcount, "following"),
                          ],
                        ),
                          Padding(
                            padding: const EdgeInsets.only(top:2),
                            child: FirebaseAuth.instance.currentUser!.uid == widget.uid ? FollowButton(
                              function: ()async{
                                await AuthMethods().SignOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                              },
                              backgroundColor: mobileBackgroundColor,
                              bordercolor: Colors.grey,
                              text: 'Sign Out',
                              textColor: primaryColor,
                            )
                                :
                            isFollowing ? FollowButton(
                              function: ()async{
                                await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);

                                setState(() {
                                  isFollowing = false;
                                  followerscount--;
                                });

                                },
                              backgroundColor: Colors.white,
                              bordercolor: Colors.grey,
                              text: 'UNFOLLOW',
                              textColor: Colors.black,
                            )
                            :
                              FollowButton(
                               function: ()async{
                                 await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);

                                 setState(() {
                                   isFollowing = true;
                                   followerscount++;
                                 });

                               },
                               backgroundColor: Colors.blue,
                               bordercolor: Colors.blue,
                               text: 'Follow',
                               textColor: Colors.white,
                              )


                          )
                      ]
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2),
                  child: Text(userData['username'],style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2),
                  child: Text(userData['bio']),
                ),
              ],
            ),
          ),
          const Divider(),

          FutureBuilder(
              future: FirebaseFirestore.instance.collection('Posts').where('uid',isEqualTo: widget.uid).get(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                    return Container(
                      child: Image(
                        image: NetworkImage(
                          snap['postUrl'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                );
              }
          )


        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.grey),
        )
      ],
    );

  }

}

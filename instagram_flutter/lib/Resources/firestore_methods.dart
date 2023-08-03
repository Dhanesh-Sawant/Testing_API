import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/Resources/storage_methods.dart';

import '../Models/posts.dart';

class FireStoreMethods{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // upload post
  Future<String> uploadPost(
      String Description,
      Uint8List file,
      String UID,
      String Username,
      String ProfileImg,
  )async{ // it returns success or failure message

    String result = "some error occurred";

    try{

      String PostId = Uuid().v1();

      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      Posts post = Posts(
        username: Username,
        uid: UID,
        postUrl: photoUrl,
        description: Description,
        ProfileImg: ProfileImg,
        datePublished: DateTime.now(),
        PostId: PostId,
        likes: [],
      );

      await _firestore.collection('Posts').doc(PostId).set(post.toJson());

      result = "Success";

    }
    catch(e){
      result = e.toString();
    }

    return result;
  }

  Future<void> LikePost(String postId, String uid, List likes) async {

    try{

      if(likes.contains(uid)){
        await _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('Posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }

    }
    catch(e){

      print(e.toString());
    }

  }

  Future<void> postComment(String postId, String text, String uid, String name, String profilePic) async {

    try{

      if(text.isNotEmpty){

        String commentId = Uuid().v1();

        await _firestore.collection('Posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic' : profilePic,
          'name': name,
          'uid' : uid,
          'text': text,
          'commentId' : commentId,
          'datePublished': DateTime.now()
        });

      }
      else print('Add some comment');

    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> deletePost(String PostId) async {

    try{

     await _firestore.collection('Posts').doc(PostId).delete();

    }
    catch(e){
      print(e.toString());
    }

  }

  Future<void> followUser(
      String uid,
      String followId
      )async{

      try{
        DocumentSnapshot snap = await _firestore.collection('Users').doc(uid).get();

        List following = (snap.data()! as dynamic)['following'];

        if(following.contains(followId)){
          await _firestore.collection('Users').doc(followId).update({
            'followers' : FieldValue.arrayRemove([uid])
          });

          await _firestore.collection('Users').doc(uid).update({
            'following' : FieldValue.arrayRemove([followId])
          });

        }
        else{
          await _firestore.collection('Users').doc(followId).update({
            'followers' : FieldValue.arrayUnion([uid])
          });

          await _firestore.collection('Users').doc(uid).update({
            'following' : FieldValue.arrayUnion([followId])
          });


        }


      }
      catch(e){
        print(e.toString());
      }

  }


}



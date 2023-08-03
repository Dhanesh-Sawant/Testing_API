import 'package:cloud_firestore/cloud_firestore.dart';

class Posts{

  final String username;
  final String uid;
  final String postUrl;
  final String description;
  final String ProfileImg;
  final datePublished;
  final String PostId;
  final List likes;

  const Posts({
    required this.username,
    required this.uid,
    required this.postUrl,
    required this.description,
    required this.ProfileImg,
    required this.datePublished,
    required this.PostId,
    required this.likes
  });

  Map<String,dynamic> toJson() => {
    'username': username,
    'uid' : uid,
    "postUrl" : postUrl,
    'description' : description,
    'ProfileImg' : ProfileImg,
    'datePublished' : datePublished,
    'likes' : likes,
    'PostId' : PostId
  };


  // take user snapshot and return user model
  static Posts fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;

    return Posts(
      username: snapshot['username'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      description: snapshot['description'],
      ProfileImg: snapshot['ProfileImg'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      PostId: snapshot['PostId'],
    );
  }

}


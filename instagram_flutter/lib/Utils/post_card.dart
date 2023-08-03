import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/Providers/user_provider.dart';
import 'package:instagram_flutter/Screens/comments_screen.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/Users.dart';
import '../Resources/firestore_methods.dart';
import '../Widgets/like_animation.dart';

class PostCard extends StatefulWidget {

  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int CommentCount = 0;

  getCommentLen() async {

    try{

      QuerySnapshot Qsnap = await FirebaseFirestore.instance.collection('Posts').doc(widget.snap['PostId']).collection('comments').get();
      CommentCount = Qsnap.docs.length;
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }

    setState(() {});

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentLen();
  }


  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(right: 0),
            child: Row(
              children: [
                 CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    widget.snap['ProfileImg']
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.snap['username'],style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                ),
                IconButton(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shrinkWrap: true,
                              children: [
                                'delete',
                                'save to favourites'
                              ].map((e) => InkWell(
                                onTap: () async{
                                    FireStoreMethods().deletePost(widget.snap['PostId']);
                                    Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12
                                  ),
                                  child: Text(e),
                                ),
                              )
                              ).toList(),
                            ),
                          )
                      );
                    },
                    icon: const Icon(Icons.more_vert)
                )
              ],
            ),

          ),

          // because heart icon when user double clicks on the post
          GestureDetector(

            onDoubleTap: ()async{
              await FireStoreMethods().LikePost(
                widget.snap['PostId'],
                user.uid,
                widget.snap['likes']
              );

              setState(() {
                isLikeAnimating = true;
              });
            },

            child: Stack(
              alignment: Alignment.center,
              children: [

                SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.35,
                child: Image.network(widget.snap['postUrl'],
                fit: BoxFit.cover
                )
              ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1:0,
                  child: LikeAnimation(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 100
                      ),
                      isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });
                    },
                  ),
                )
              ]
            ),
          ),

          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: ()async{

                      await FireStoreMethods().LikePost(
                          widget.snap['PostId'],
                          user.uid,
                          widget.snap['likes']
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid) ? Icon(
                        Icons.favorite, color: Colors.red,
                    ) :
                        Icon(Icons.favorite_border, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ))),
                icon: Icon(Icons.comment_outlined),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.send),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.bookmark_border)
                    ),
                  )
              )
            ],
          ),

          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 8),
                    child: RichText( // no need to create row or can give multiple theme to multiple texts
                      text: TextSpan(
                        style: TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '  ${widget.snap['description']}',
                          )
                        ]
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $CommentCount comments',
                        style: TextStyle(fontSize: 15,color: secondaryColor)
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate()
                        ),
                        style: TextStyle(fontSize: 15,color: secondaryColor)
                    ),
                  )


                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

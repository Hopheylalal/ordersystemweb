import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordersystemweb/admin/comment_widget.dart';
import 'package:ordersystemweb/admin/master_widget.dart';

import 'order_widget.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('comments')
                  .orderBy('createDate', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text('Всего отзывов: ${snapshot.data.docs.length}'),
                      Column(

                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                            return CommentWidget(
                              ownerName: documentSnapshot.data()['ownerName'],
                              masterId: documentSnapshot.data()['masterId'],
                              commentUid: documentSnapshot.id,
                              time: DateTime.parse(
                                documentSnapshot
                                    .data()['createDate']
                                    .toDate()
                                    .toString(),
                              ),
                              content: documentSnapshot.data()['content'],
                            );
                          }).toList().cast<Widget>()),
                    ],
                  );
                }
                return LinearProgressIndicator();
              }),
        ],
      ),
    );
  }
}

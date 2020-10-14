import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordersystemweb/admin/respond_widget.dart';
import 'package:ordersystemweb/firebase.dart';

import 'comment_widget.dart';
import 'order_widget.dart';

class UserScreen extends StatefulWidget {
  final String masterNmae;
  final String masterUid;

  const UserScreen({
    Key key,
    this.masterNmae,
    this.masterUid,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String mode = 'comment';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.masterNmae),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      mode = 'comment';
                    });
                  },
                  child: Text('Отзывы'),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      mode = 'order';
                    });
                  },
                  child: Text('Заказы'),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  mode == 'comment'
                      ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where('ownerId', isEqualTo: widget.masterUid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return LinearProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                      'Всего отзывов от клиента: ${snapshot.data.docs.length}'),
                                ),
                              ),
                              Column(
                                children: snapshot.data.docs.map<Widget>(
                                        (DocumentSnapshot documentSnapshot) {
                                      return CommentWidget(
                                        ownerName:
                                        documentSnapshot.data()['ownerName'],
                                        masterId:
                                        documentSnapshot.data()['masterId'],
                                        commentUid: documentSnapshot.id,
                                        time: DateTime.parse(
                                          documentSnapshot
                                              .data()['createDate']
                                              .toDate()
                                              .toString(),
                                        ),
                                        content: documentSnapshot.data()['content'],
                                      );
                                    }).toList(),
                              ),
                            ],
                          );
                        }
                        return LinearProgressIndicator();
                      })
                      : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('orders')
                          .where('owner', isEqualTo: widget.masterUid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return LinearProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                      'Всего заказов от клиента: ${snapshot.data.docs.length}'),
                                ),
                              ),
                              Column(
                                children: snapshot.data.docs.map<Widget>(
                                        (DocumentSnapshot documentSnapshot) {
                                      return OrderWidget(
                                        title:
                                        documentSnapshot.data()['title'],
                                        createDate: DateTime.parse(
                                          documentSnapshot
                                              .data()['createDate']
                                              .toDate()
                                              .toString(),
                                        ),
                                        orderId: documentSnapshot.data()['orderId'],
                                        description: documentSnapshot.data()['description'],
                                        name: documentSnapshot.data()['name'],
                                        masterName: documentSnapshot.data()['masterName'],
                                        // category: documentSnapshot.data()['category'],
                                      );
                                    }).toList(),
                              ),
                            ],
                          );
                        }
                        return LinearProgressIndicator();
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

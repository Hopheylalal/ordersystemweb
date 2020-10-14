import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordersystemweb/admin/respond_widget.dart';

import 'comment_widget.dart';
import 'order_widget.dart';

class MasterScreen extends StatefulWidget {
  final String masterNmae;
  final String masterUid;

  const MasterScreen({
    Key key,
    this.masterNmae,
    this.masterUid,
  }) : super(key: key);

  @override
  _MasterScreenState createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  String mode = 'comment';

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
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      mode = 'respond';
                    });
                  },
                  child: Text('Заказы'),
                ),
              ],
            ),
            Column(
              children: [
                mode == 'comment'
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .where('masterId', isEqualTo: widget.masterUid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                      'Всего отзывов: ${snapshot.data.docs.length}'),
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
                          return CircularProgressIndicator();
                        })
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('toMaster', isEqualTo: widget.masterUid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
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
                                        'Всего заказов у мастера: ${snapshot.data.docs.length}'),
                                  ),
                                ),
                                Column(
                                  children: snapshot.data.docs.map<Widget>(
                                      (DocumentSnapshot documentSnapshot) {
                                    return OrderWidget(
                                      name:
                                          documentSnapshot.data()['name'],
                                        createDate: DateTime.parse(
                                          documentSnapshot
                                              .data()['createDate']
                                              .toDate()
                                              .toString(),
                                        ),
                                      orderId: documentSnapshot.data()['orderId'],
                                      title: documentSnapshot.data()['title'],
                                      description: documentSnapshot.data()['description'],
                                      masterName: documentSnapshot.data()['masterName'],
                                      // category: documentSnapshot.data()['category'],
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          }
                          return CircularProgressIndicator();
                        }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

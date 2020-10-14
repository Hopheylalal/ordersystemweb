import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordersystemweb/admin/master_widget.dart';

class Masters extends StatefulWidget {
  @override
  _MastersState createState() => _MastersState();
}

class _MastersState extends State<Masters> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('masters')
                  .where('userType', isEqualTo: 'master')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LinearProgressIndicator());
                } else {
                  return Column(
                    children: [
                      Text('Всего мастеров: ${snapshot.data.docs.length}'),
                      Column(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return MasterWidget(
                              name: documentSnapshot.data()['name'],
                              email: Text(documentSnapshot.data()['email']),
                              phone: Text(documentSnapshot.data()['phoneNumber']),
                              createDate: documentSnapshot.data()['createDate'],
                              aboutShort:
                                  Text(documentSnapshot.data()['aboutShort']),
                              aboutLong:
                                  Text(documentSnapshot.data()['aboutLong']),
                              category: documentSnapshot.data()['category'],
                              masterID: documentSnapshot.data()['userId'],
                              blocked: documentSnapshot.data()['blocked'],
                            );
                            //   Card(
                            //     child: Text(
                            //   documentSnapshot.data()['name'],
                            // ));
                          }).toList()),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}

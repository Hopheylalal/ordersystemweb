import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordersystemweb/admin/master_widget.dart';
import 'package:ordersystemweb/admin/user_widget.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('masters').where('userType',isEqualTo: 'user').get(),
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.done){
                return Text('Всего клиентов: ${snapshot.data.docs.length}');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Container();
              }
              return Text('...');
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('masters').where('userType',isEqualTo: 'user').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LinearProgressIndicator());
                } else {
                  return new Column(
                      children:
                      snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                        return
                          UserWidget(
                            name: documentSnapshot.data()['name'],
                            email: Text(documentSnapshot.data()['email']),
                            createDate: DateTime.parse(
                              documentSnapshot
                                  .data()['createDate']
                                  .toDate()
                                  .toString(),
                            ),
                            masterID: documentSnapshot.data()['userId'],
                            blocked: documentSnapshot.data()['blocked'],
                          );
                        //   Card(
                        //     child: Text(
                        //   documentSnapshot.data()['name'],
                        // ));
                      }).toList());
                }
              }),
        ],
      ),
    );
  }
}

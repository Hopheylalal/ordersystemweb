import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordersystemweb/admin/master_screen.dart';
import 'package:ordersystemweb/admin/user_screen.dart';

class UserWidget extends StatelessWidget {
  final String name;
  final Widget email;
  final DateTime createDate;
  final String masterID;
  final bool blocked;

  const UserWidget(
      {Key key,
        this.name,
        this.email,
        this.createDate,
        this.masterID, this.blocked})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Имя',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.info,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserScreen(masterNmae: name, masterUid: masterID,),
                                ),
                              );
                            },
                          ),
                          blocked == false
                              ? IconButton(
                            icon: Icon(
                              Icons.block,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('masters')
                                  .doc(masterID)
                                  .update({'blocked': true});
                            },
                          )
                              : IconButton(
                            icon: Icon(
                              Icons.done_all_outlined,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('masters')
                                  .doc(masterID)
                                  .update({'blocked': false});
                            },
                          )
                        ],
                      ),

                    ],
                  ),
                  Text(name),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  email,
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Дата регистрации',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text(createDate.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// snapshot.data.docs.map<Widget>((DocumentSnapshot documentSnapshot){
// return CommentWidget(
// ownerName: documentSnapshot.data()['ownerName'],
// masterId: documentSnapshot.data()['masterId'],
// time: documentSnapshot.data()['createDate'],
// content: documentSnapshot.data()['content'],
// );
// }).toList(),

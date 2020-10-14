import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ordersystemweb/admin/master_widget.dart';

import 'order_widget.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .orderBy('createDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var orders = snapshot.data.docs;
                  return Column(
                    children: [
                      Text('Всего заказов: ${snapshot.data.docs.length}'),
                      Column(
                        children: snapshot.data.docs.map<Widget>((e){
                          return OrderWidget(
                            title: e.data()['title'],
                            createDate: e.data()['createDate'].toDate(),
                            description: e.data()['description'],
                            orderId: e.data()['orderId'],
                            name: e.data()['name'],
                            masterName: e.data()['masterName'],

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
    );
  }
}

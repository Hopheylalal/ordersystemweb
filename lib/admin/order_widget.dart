import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  final int orderId;
  final String title;
  final String description;
  final DateTime createDate;
  final String category;
  final String name;
  final String masterName;
  final String ownerId;

  const OrderWidget(
      {Key key,
      this.orderId,
      this.title,
      this.description,
      this.createDate,
      this.category,
      this.name,
      this.ownerId, this.masterName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    print('wwww$orderId');

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Название:'),
                    Text(title),
                    Text('Задание от: $name'),
                    Text('Задание мастеру: $masterName'),
                    Text('Дата размещения:'),
                    Text(createDate.toString()),
                    Text('Описание:'),
                    Text(description),
                    Text(orderId.toString()),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Future<void> deleteOrder() {
                      return orders.doc(orderId.toString()).delete().then(
                          (value) {
                        print("Order Deleted");
                      }).catchError(
                          (error) => print("Failed to delete order: $error"));
                    }

                    deleteOrder();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

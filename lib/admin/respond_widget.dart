import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RespondWidget extends StatelessWidget {
  final String content;
  final DateTime time;
  final String orderOwnerName;
  final int orderId;
  final int respondId;
  final String orderTitle;
  final String orderOwnerUid;

  const RespondWidget(
      {Key key,
      this.content,
      this.time,
      this.orderOwnerName,
      this.orderId,
      this.respondId,
      this.orderTitle,
      this.orderOwnerUid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference responds =
        FirebaseFirestore.instance.collection('responds');

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orderOwnerName),
                  Text('$time'),
                  Text(content),
                ],
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Future<void> deleteRespond() {
                      return responds.doc(respondId.toString()).delete().then((value) {
                        print("Respond Deleted");
                      }).catchError(
                          (error) => print("Failed to delete respond: $error"));
                    }

                    deleteRespond();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

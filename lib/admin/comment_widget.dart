import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final String content;
  final DateTime time;
  final String ownerName;
  final String masterId;
  final String commentUid;
  final String masterName;

  const CommentWidget(
      {Key key,
      this.content,
      this.time,
      this.ownerName,
      this.masterId,
      this.commentUid, this.masterName})
      : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  Future<String> getAdminName()async{
    DocumentSnapshot adminNameSnapshot = await FirebaseFirestore.instance.collection('masters').doc(widget.masterId).get();
    String  adminName = adminNameSnapshot.data()['name'];
    print('111$adminName');
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');

    CollectionReference masters = FirebaseFirestore.instance.collection('masters');

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: masters.doc(widget.masterId).get(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('От: ${widget.ownerName}'),
                          Text('Кому: ${snapshot.data.data()['name']}'),
                          Text('${widget.time}'),
                          Text(widget.content),

                        ],
                      );
                    }
                    return SizedBox();


                  }),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Future<void> deleteComment() {
                      return comments.doc(widget.commentUid).delete().then((value) {
                        print("Comment Deleted");
                      }).catchError(
                          (error) => print("Failed to delete comment: $error"));
                    }

                    deleteComment();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

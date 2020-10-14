import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width / 2 ,
                  child: TextFormField(
                    controller: _editingController,
                    decoration: InputDecoration(
                      hintText: 'Добавьте категорию'
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text('Добавить'),
                  onPressed: (){
                    if(_editingController.text.isNotEmpty){
                      List add = [];
                      add.add(_editingController.text);

                      FirebaseFirestore.instance
                          .collection('category')
                          .doc('BY7oiRIc6uq14MwsJ9yV')
                          .update({'cats' : FieldValue.arrayUnion(add) }).whenComplete((){
                        _editingController.clear();
                        setState(() {

                        });
                      });
                    }

                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('category')
                  .doc('BY7oiRIc6uq14MwsJ9yV')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List cats = snapshot.data.data()['cats'];
                  print(cats[0]);
                  return Column(
                    children: cats.where((element) => element != '1все')
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        print(cats);
                                        cats.remove(e);
                                        FirebaseFirestore.instance
                                            .collection('category')
                                            .doc('BY7oiRIc6uq14MwsJ9yV')
                                            .update(
                                          {'cats': cats},
                                        );
                                        print(cats);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
                return LinearProgressIndicator();
              }),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ordersystemweb/admin/admin_home.dart';
import 'dart:math';
import 'firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminHome(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerDescription =
      TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Random random = new Random();
  bool loading = false;

  FirebaseServices _firebaseServices = FirebaseServices();
  String _chosenValue;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  void addOrder()async{
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          loading = true;
        });
        int randomNumber = random.nextInt(1000000);
        await _firebaseServices
            .registerEmailAndPassword(
          name: textEditingControllerName.text.trim(),
          email: textEditingControllerEmail.text.trim(),
          password: randomNumber.toString().trim(),
          imgUrl:
          'https://firebasestorage.googleapis.com/v0/b/orderfinder-5e185.appspot.com/o/account.png?alt=media&token=cfc78a03-0404-4194-b7e3-60b77c374ffe',
        )
            .whenComplete(() {
          String userUid = _firebaseServices.getUser();

          int dateId = DateTime.now().millisecondsSinceEpoch;
          FirebaseFirestore.instance
              .collection('orders')
              .doc('$dateId')
              .set({
            'owner': userUid,
            'createDate': DateTime.now(),
            'name': textEditingControllerName.text,
            'title': textEditingControllerTitle.text,
            'description': textEditingControllerDescription.text,
            'orderId': dateId,
            'category': _chosenValue,
          });
          setState(() {
            loading = false;
          });

        });

        textEditingControllerName.clear();
        textEditingControllerEmail.clear();
        textEditingControllerDescription.clear();
        textEditingControllerTitle.clear();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Ваша заявка принята!",
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      print('Failed with error code: ${e.code}');
      print(e.message);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Такой почтовый ящик уже зарегистрован.",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Система приема заказов'),
        actions: [
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminHome(),
                  ),
                );
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: AutoSizeText(
                  'Оставьте ваш заказ и мастер свяжется с вами в ближайшее время.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Введите название' : null,
                    controller: textEditingControllerTitle,
                    decoration:
                        InputDecoration(labelText: 'Короткое название задания'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Введите описание' : null,
                    controller: textEditingControllerDescription,
                    decoration: InputDecoration(labelText: 'Описание задания'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (val) => val.isEmpty ? 'Введите ваше имя' : null,
                    controller: textEditingControllerName,
                    decoration: InputDecoration(labelText: 'Ваше имя'),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    validator: (val) => val.isEmpty || !val.contains('@')
                        ? 'Введите корректный Email'
                        : null,
                    controller: textEditingControllerEmail,
                    decoration: InputDecoration(labelText: 'Укажите ваш email'),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('category')
                    .doc('BY7oiRIc6uq14MwsJ9yV')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          'Выберите специализацию',
                        ),
                        value: _chosenValue,
                        items: snapshot.data
                            .data()['cats']
                            .cast<String>()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: RaisedButton(
                  onPressed: loading == false ? addOrder : null,
                  child: Text('Отправить заказ'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

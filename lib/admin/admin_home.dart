
import 'package:flutter/material.dart';
import 'package:ordersystemweb/admin/category.dart';
import 'package:ordersystemweb/admin/comments.dart';
import 'package:ordersystemweb/admin/masters.dart';
import 'package:ordersystemweb/admin/orders.dart';
import 'package:ordersystemweb/admin/users.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  String mode = 'master';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Панель администратора'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: [
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      mode = 'master';
                    });
                  },
                  child: Text('Мастера'),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      mode = 'user';
                    });
                  },
                  child: Text('Пользователи'),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      mode = 'order';
                    });
                  },
                  child: Text('Заказы'),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      mode = 'comments';
                    });
                  },
                  child: Text('Отзывы'),
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                      mode = 'cats';
                    });
                  },
                  child: Text('Специализации'),
                )
              ],
            ),
            Divider(
              color: Colors.blue,
              height: 5,
            ),
            if(mode == 'master')
            Masters()
            else if(mode == 'user')
              Users()
            else if(mode == 'order')
              Orders()
            else if (mode == 'comments')
              Comments()
            else if (mode == 'cats')
              Category()
          ],
        ),
      ),
    );
  }
}

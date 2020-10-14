import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FirebaseServices{

  final _firebaseAuth = FirebaseAuth.instance;

  String getUser(){
    String userUid = _firebaseAuth.currentUser.uid;
    return userUid;
  }

  Future registerEmailAndPassword({
   String email,
   String password,
   String name,
   String imgUrl,

 }) async {
   UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
       email: email, password: password);

   User user = result.user;

   //Создаем нового юзера в firebase
   FirebaseFirestore.instance.collection('masters').doc(user.uid).set({
     'token': '',
     'email' : email,
     'name' : name,
     'createDate' : FieldValue.serverTimestamp(),
     'userId' : user.uid,
     'userType' : 'user',
     'imgUrl' : imgUrl,
     'fromWeb' : true,
     'pass' : password,
     'blocked' :false,

   });

   user.updateProfile(displayName: name).catchError((e) => print(e));
 }


}


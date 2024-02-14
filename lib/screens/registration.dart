import 'dart:developer';

import 'package:chat_app/extensions/buildContextExtension.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/users.dart';
import 'package:chat_app/styles/constant_styles.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
   const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final namecontroller = TextEditingController();

  final emailcontroller = TextEditingController();

  final passwordontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Registration", style: titleTextStyle),
          CustomTextField(hintText: 'Name', isPassword: false, icon: Icons.person,controller: namecontroller,),
          CustomTextField(hintText: 'Email', isPassword: false, icon: Icons.email,controller: emailcontroller,),
          CustomTextField(hintText: 'Password', isPassword: true, icon: Icons.lock,controller: passwordontroller),
          ElevatedButton(onPressed: (){
            registerNewUser();
          }, child: Text("register now")),
          GestureDetector(
            onTap: () => {
                  Navigator.pop(context)
            },
            child: const Text('Already a user, Login instead'),
          ),
          


          
        ],
      ),
    );
  }

 Future <void> registerNewUser()async{
  final email = emailcontroller.text;
  final password = passwordontroller.text;
  if(email.isNotEmpty && password.isNotEmpty){

  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then(
    (value) {
      log(value.user!.uid);
      addDataToDatabase(uid: value.user!.uid);
      }
    );
  }
 }

 Future<void> addDataToDatabase({required String uid}) async{
  final user = Users(
    namecontroller.text,
    emailcontroller.text,
    uid,
    passwordontroller.text,
    true,
    'say cheese');
  FirebaseFirestore.instance.collection('users').add(user.toJson())
  .then((value){
    log('user created successfully');
    context.navigateToScreen(const MainChatScreen(), isReplace: true);
  }).catchError((e){
    log('failed to create user $e');
  });
 }
}
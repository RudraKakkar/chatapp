import 'package:chat_app/extensions/buildContextExtension.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/registration.dart';
import 'package:chat_app/styles/constant_styles.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailcontroller = TextEditingController();

  final passwordontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Login", style: titleTextStyle),
          CustomTextField(hintText: 'Email', isPassword: false, icon: Icons.email,controller: emailcontroller,),

          CustomTextField(hintText: 'Password', isPassword: true, icon: Icons.lock,controller: passwordontroller,),
          ElevatedButton(
            onPressed: (){
              loginUser();

          }, child: const Text("login")),
          GestureDetector(
            onTap: () => {
                  context.navigateToScreen(Registration())
            },
            child: const Text('new user ? create new account'),
          )


          
        ],
      ),
    );
  }

  Future<void> loginUser() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcontroller.text, password: passwordontroller.text)
    .then((value){
      context.navigateToScreen(MainChatScreen(),isReplace: true);
    });
  }
}


import 'package:chat_app/extensions/buildContextExtension.dart';
import 'package:chat_app/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  final msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text("Char Room"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  context.navigateToScreen(LoginScreen(), isReplace: true);
                }).catchError((e) {});
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Stack(children: [
        StreamBuilder<QuerySnapshot>
        (stream:
          FirebaseFirestore.instance.collection('messages').orderBy('timeStamp',descending: true).snapshots() ,
          builder:(context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
                );

            }else if(snapshot.hasError){
              return Center(
                child:Text("Failed to fetch messages")
              );

            }else if(snapshot.hasData){
              final messages = snapshot.data!.docs;
              return Positioned(
                  top:0,
                  left:0,
                  right: 0,
                  bottom:120,

                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount:messages.length,
                    itemBuilder: ((context, index){
                      return ListTile(
                        title: Text(messages[index]['message']),
                        subtitle:Row(
                          children: [
                            Text(messages[index]['senderEmail']),
                            // Text(DateTime.fromMicrosecondsSinceEpoch(messages[index]['timestamp']).toString())
                          ],
                        ) ,
                        );
                    }),
                    ),
                );
              }
            else{
              return Center(
                child: Text('No message'),
              );
            }
          }),
        
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 100,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.only(bottom:10,left:20),
              child: Row(
                children: [
                  SizedBox(
                    
                    width: context.getWidth(percentage: 0.8),
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: (  
                    ) {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> sendMessage() async {
    if (msgController.text.isNotEmpty) {
      final message = {
        'message': msgController.text,
        'sendUid': FirebaseAuth.instance.currentUser!.uid,
        'senderEmail':FirebaseAuth.instance.currentUser!.email,
        'timeStamp': DateTime.now().millisecondsSinceEpoch
      };
      FirebaseFirestore.instance
          .collection('messages')
          .add(message)
          .then((value) {
        msgController.clear();
      });
    }
  }
  void getMessages(){
    FirebaseFirestore.instance
    .collection('messages')
    .snapshots()
    .listen((event){

    });
  }
}

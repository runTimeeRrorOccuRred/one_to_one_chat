import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatelessWidget {


  final Map<String,dynamic>? userMap;
  final String? chatRoomId;


  ChatRoom({  this.userMap, this.chatRoomId});
  final TextEditingController message=TextEditingController();
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  void onSendMessage()async
  {
   if(message.text.isNotEmpty)
     {
       Map<String,dynamic> messages={
         "sendby":firebaseAuth.currentUser!.displayName,
         "message":message.text,
         "time":FieldValue.serverTimestamp(),

       };
       await firebaseFirestore.collection('chatroom').doc(chatRoomId).collection('chats').add(messages);
       message.clear();
     }
   else
     {
       print("Please enter some text");
     }
  }
  @override

  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.video_call),
          SizedBox(width: 10,),
          Icon(Icons.phone)
        ],
        title: Text(userMap!['name']),
      ),
      body: SingleChildScrollView(
        child:Column(
        children: [
          Container(
            height: size.height/1.2,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore.collection('chatroom').doc(chatRoomId).collection('chats').orderBy('time',
                  descending: false).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot)
              {
                if(snapshot.data!=null)
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          Map<String,dynamic> map= snapshot.data!.docs[index].data() as Map<String,dynamic>;
                         return messages(size, map);

                    });
                  }
                else
                  {
                    return Container();
                  }
              },


            ),
          ),
          // bottomNavigationBar: Container(
          //   height: size.height/12,
          //   width: size.width/1.1,
          //   child: Row(
          //     children: [
          //       Container(
          //         height: size.height/12,
          //         width: size.width/1.5,
          //         child: TextField(
          //           controller: message,
          //           decoration: InputDecoration(
          //               border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(8)
          //               )
          //           ),
          //         ),
          //       ),
          //       IconButton(onPressed: (){}, icon: Icon(Icons.send))
          //     ],
          //   ),
          // ),

          Container(
            height: size.height/10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/12,
              width: size.width/1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.attach_file),
                  Container(
                    height: size.height/17,
                    width: size.width/1.4,
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        hintText: "Type Message...",
                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    onSendMessage();
                  }, icon: Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),)



    );
  }
  Widget messages(Size size,Map<String,dynamic>map)
  {
    return Container(
      width: size.width,
      alignment: map['sendby'] == firebaseAuth.currentUser?.displayName? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: map['sendby'] == firebaseAuth.currentUser?.displayName?Colors.blue:Colors.grey
        ),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
        child: Text(map['message'],
        style: TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }
}

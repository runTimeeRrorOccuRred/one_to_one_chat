import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chatapp/chat/chatroom.dart';
import 'package:one_to_one_chatapp/loginpage.dart';
import 'package:one_to_one_chatapp/methods.dart';
class HomeScreen extends StatefulWidget {
  String? userName;
   HomeScreen({this.userName,Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  //FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  Map<String,dynamic>? userMap;
  bool isLoading=false;
  final TextEditingController search=TextEditingController();
  String chatRoomId(String? user1,user2)
  {
    if(user1![0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0])
      {
        return "$user1$user2";
      }
    else
      {
        return "$user2$user1";
      }
  }
 void onSearch()async
 {
   setState(() {
     isLoading=true;
   });
   FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
   await firebaseFirestore.collection('users').where("email",isEqualTo: search.text).get().then((value){
    if(value!=null) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    }
    else
      {
        print("User not found");
        setState(() {
          isLoading=false;
        });
      }
   });

 }
  @override

  Widget build(BuildContext context) {

    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"),
      actions: [
        IconButton(onPressed: (){
          logOut(context);
        }, icon: Icon(Icons.exit_to_app))
      ],),
      body:isLoading?Center(child: CircularProgressIndicator()): Column(

        children: [
          SizedBox(
            height: size.height/20,
          ),
          Container(
            height: size.height/14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width/1.2,
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height/30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(


                  primary: Colors.indigo.withOpacity(0.7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: (){
            onSearch();
          }, child: Text("Search",
          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
          SizedBox(
            height: size.height/50,
          ),
          userMap!=null?ListTile(
            onTap: (){

             print(widget.userName);
              String roomId= chatRoomId(widget.userName, userMap!['name']);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoom(
                userMap: userMap,
                chatRoomId: roomId,
              )));
              print("working");
            },
            leading: Icon(Icons.account_box,color: Colors.black,),
            title: Text(userMap?['name'],style: TextStyle(color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500),),
            subtitle: Text(userMap?['email']),
            trailing: Icon(Icons.chat,
            color: Colors.black,),
          ):Container()
        ],
      )
    );
  }


}

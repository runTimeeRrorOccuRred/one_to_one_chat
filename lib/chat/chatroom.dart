import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  final String? chatRoomId;

  ChatRoom({this.userMap, this.chatRoomId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // Future<void> requestPermissions() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     // Request storage permission
  //     await Permission.storage.request();
  //   }
  // }

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": firebaseAuth.currentUser!.displayName,
        "message": message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await firebaseFirestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      message.clear();
    } else {
      print("Please enter some text");
    }
  }

  // Future<void> uploadImage() async {
  //   await requestPermissions();
  //   if (await Permission.storage.request().isGranted) {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //     if (image != null) {
  //       final fileName = image.name;
  //       final destination = 'chatImages/$fileName';

  //       try {
  //         final ref = FirebaseStorage.instance.ref(destination);
  //         final uploadTask = ref.putFile(File(image.path));

  //         await uploadTask.whenComplete(() async {
  //           final imageUrl = await ref.getDownloadURL();

  //           Map<String, dynamic> imageMessage = {
  //             "sendby": firebaseAuth.currentUser!.displayName,
  //             "message": "",
  //             "imageUrl": imageUrl,
  //             "time": FieldValue.serverTimestamp(),
  //           };

  //           await firebaseFirestore
  //               .collection('chatroom')
  //               .doc(widget.chatRoomId)
  //               .collection('chats')
  //               .add(imageMessage);
  //         });
  //       } catch (e) {
  //         print("Failed to upload image: $e");
  //       }
  //     }
  //   } else {
  //     // Handle the case when storage permission is not granted
  //     print("Storage permission is not granted");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userMap!['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Text(
                  widget.userMap!['name'],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                (snapshot.hasData)
                    ? Text(snapshot.data!['status'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15))
                    : const Text("Unavailable")
              ],
            );
          },
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle phone call action
            },
          ),
          const SizedBox(width: 10), // Add some space at the end if needed
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        String messageId = documentSnapshot.id;
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messageTile(size, map, messageId, context);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.attach_file, color: Colors.deepPurple),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextField(
                        controller: message,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: onSendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(
      Size size, Map<String, dynamic> map, String messageId, context) {
    bool isMe = map['sendby'] == firebaseAuth.currentUser?.displayName;
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    deleteMessage(context, widget.chatRoomId, messageId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text("Message Deleted"),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: isMe ? size.width * 0.25 : 8.0,
          right: isMe ? 8.0 : size.width * 0.25,
          top: 8.0,
          bottom: 8.0,
        ),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: isMe ? Colors.deepPurple : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              map['imageUrl'] != null
                  ? Image.network(map['imageUrl'])
                  : Text(
                      map['message'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
              Text(
                map['time'] != null
                    ? DateFormat('hh:mm a').format(map['time'].toDate())
                    : '',
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteMessage(
      BuildContext context, String? chatRoomId, String messageId) async {
    await firebaseFirestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .delete();
  }
}

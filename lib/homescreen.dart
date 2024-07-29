import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_to_one_chatapp/chat/chatroom.dart';
import 'package:one_to_one_chatapp/loginpage.dart';
import 'package:one_to_one_chatapp/methods.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  HomeScreen({this.userName, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> userStream;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  void onSearch() {
    setState(() {
      if (searchController.text.isEmpty) {
        userStream = FirebaseFirestore.instance.collection('users').snapshots();
      } else {
        userStream = FirebaseFirestore.instance
            .collection('users')
            .where('name', isEqualTo: searchController.text)
            .snapshots();
      }
    });
  }

  String chatRoomId(String? user1, String user2) {
    if (user1 != null) {
      return user1[0].toLowerCase().codeUnits[0] >
              user2.toLowerCase().codeUnits[0]
          ? "$user1$user2"
          : "$user2$user1";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TalkNest",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              tooltip: 'Log Out',
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: onSearch,
                  ),
                  prefixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            onSearch();
                          },
                        )
                      : null,
                  hintText: "Search by name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: false,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Users Found"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              String roomId =
                                  chatRoomId(widget.userName, user['name']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                    userMap: user,
                                    chatRoomId: roomId,
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                user['name'][0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              user['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(user['email']),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

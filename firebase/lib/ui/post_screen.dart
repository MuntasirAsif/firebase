import 'package:firebase/ui/auth/add_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../widget/ticket_view.dart';

class PostScrren extends StatefulWidget {
  const PostScrren({Key? key}) : super(key: key);

  @override
  State<PostScrren> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScrren> {
  DatabaseReference ref = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://fir-aa282-default-rtdb.asia-southeast1.firebasedatabase.app')
      .ref("post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                scrollDirection: Axis.horizontal,
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 5),
                      scrollDirection: Axis.horizontal,
                      child: InkWell(
                        child: TicketView(
                          photo: snapshot.child('image').value.toString(),
                          formAdd: snapshot.child('fromAdd').value.toString(),
                          toAdd: snapshot.child('toAdd').value.toString(),
                          space: snapshot.child('spaceName').value.toString(),
                          price: snapshot.child('price').value.toString(), launceDate: snapshot.child('lunchingDate').value.toString(),
                        ),
                        onTap: () {},
                      ));
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
/*
Expanded(
child: StreamBuilder(
stream: ref.onValue, builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
if(!snapshot.hasData){
return const CircularProgressIndicator();
}
else{
return ListView.builder(
itemCount : snapshot.data?.snapshot.children.length,
itemBuilder: (context, index){
return  const ListTile(

);
});
}
},
),
),
*/

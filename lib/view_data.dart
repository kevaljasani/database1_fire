import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database1_fire/main.dart';
import 'package:flutter/material.dart';

class second extends StatefulWidget {
  const second({super.key});

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {

  CollectionReference users = FirebaseFirestore.instance.collection('cdmi');
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('cdmi').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),

      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['contact']),
                  trailing: Wrap(
                    children: [
                      
                      IconButton(onPressed: () {

                        users
                            .doc(document.id)
                            .delete()
                            .then((value) {
                          print("User Deleted");
                        })
                            .catchError((error) => print("Failed to delete user: $error"));

                      }, icon: Icon(Icons.delete)),
                      
                      IconButton(onPressed: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return first(document.id,data['name'],data['contact']);
                        },));

                      }, icon: Icon(Icons.edit))
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

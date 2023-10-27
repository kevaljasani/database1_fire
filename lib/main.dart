import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database1_fire/view_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(MaterialApp(home: first(),));
}

class first extends StatefulWidget {
  String ? id;
  String ? name;
  String ? contact;

  first([this.id,this.name,this.contact]);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('cdmi');

  @override
  void initState() {

    if(widget.id != null)
      {
        t1.text=widget.name!;
        t2.text=widget.contact!;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(),

      body: Column(children: [
        
        TextField(
          controller: t1,
        ),
        
        TextField(
          controller: t2,
        ),
        
        ElevatedButton(onPressed: () {

          String name=t1.text;
          String contact=t2.text;

          if(widget.id != null)
          {
            users
                .doc(widget.id)
                .update({'name': name,'contact': contact})
                .then((value) {
              print("User Updated");
            })
                .catchError((error) => print("Failed to update user: $error"));
          }
          else
            {
              users
                  .add({
                'name': name, // John Doe
                'contact': contact, // Stokes and Sons
              })
                  .then((value) {
                print("User Added");
              })
                  .catchError((error) => print("Failed to add user: $error"));
            }

        }, child: Text("Submit")),
        
        ElevatedButton(onPressed: () {
          
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return second();
          },));

        }, child: Text("View"))
      ],),
    );
  }
}

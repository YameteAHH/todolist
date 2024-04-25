import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/components/todolistfile_.dart';
import 'package:todolist/service/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  FirestoreService tasks = FirestoreService();
  void openDialogBox({String? docID}) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      content: TextField(
        controller: textEditingController,
      ),
      actions: [
       ElevatedButton(
        onPressed: docID == null
        ? () {
          tasks.addTask(textEditingController.text);
          Navigator.pop(context);
        } 
        : () {
          tasks.updateTask(docID, textEditingController.text);
          Navigator.pop(context); 
        }, 
        child: Icon(
          Icons.add,
       ))
    ],
   ), 
  );
}

void onDelete(String docID) {
  tasks.deleteTask(docID);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[300],
        onPressed:() {
          openDialogBox();
        },
          child: const Icon(
            Icons.add,
        ),
      ),
      backgroundColor: Colors.cyan[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan[300],
        title: const Text(
          'TODO LIST',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: tasks.getTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List tasksList = snapshot.data.docs;
            return ListView.builder(
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = tasksList[index];
                return ToDoListFile(
                  data: doc['task'],
                  onPressed: () => openDialogBox(docID: doc.id),
                  onDelete: () => onDelete(doc.id)
                );
              }
            );
          } else {
            return Center(child: Text('Loading data...'));
          }
        },
      ),
    );
  }
}

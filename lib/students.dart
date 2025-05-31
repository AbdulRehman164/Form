import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  List<Student> students = [];
  String? error;

  void fetchStudents() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('students').get();

      final fetchedStudents =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return Student(
              data['name'] ?? '',
              data['ag_number'] ?? '',
              data['age'],
              data['email'] ?? '',
              data['department'] ?? '',
            );
          }).toList();

      setState(() {
        students = fetchedStudents;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        backgroundColor: Colors.amber,
      ),
      body: ,
    );
  }
}

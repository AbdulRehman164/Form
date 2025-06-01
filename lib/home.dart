import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formpage.dart';
import 'student.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              doc.id,
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

  void deleteStudent(String id) async {
    try {
      await FirebaseFirestore.instance.collection('students').doc(id).delete();
      fetchStudents(); // Refresh list
    } catch (e) {
      setState(() {
        error = 'Delete failed: $e';
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
    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading students:\n$error')),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            "My Database App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final s = students[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormPage(student: s),
                                  ),
                                ).then((_) => fetchStudents());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteStudent(s.id),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text('AG Number: ${s.agNumber}'),
                    Text('Age: ${s.age}'),
                    Text('Email: ${s.email}'),
                    Text('Department: ${s.department}'),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormPage()),
            ).then((_) {
              fetchStudents();
            });
          },
          tooltip: 'Increment',
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

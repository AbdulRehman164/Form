import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student.dart';

class FormPage extends StatefulWidget {
  final Student? student;

  const FormPage({super.key, this.student});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final agNumCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final departmentCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameCtrl.text = widget.student!.name;
      agNumCtrl.text = widget.student!.agNumber;
      ageCtrl.text = widget.student!.age?.toString() ?? '';
      emailCtrl.text = widget.student!.email;
      departmentCtrl.text = widget.student!.department;
    }
  }

  Widget customTextField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Please enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      final studentData = {
        'name': nameCtrl.text,
        'ag_number': agNumCtrl.text,
        'age': int.tryParse(ageCtrl.text),
        'email': emailCtrl.text,
        'department': departmentCtrl.text,
      };

      try {
        if (widget.student == null) {
          await FirebaseFirestore.instance
              .collection('students')
              .add(studentData);
        } else {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(widget.student!.id)
              .update(studentData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.student == null
                  ? 'Data uploaded successfully'
                  : 'Data updated successfully',
            ),
          ),
        );
        Navigator.pop(context); // Return to home
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(
            widget.student == null ? "Add Student" : "Edit Student",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                customTextField('Name', nameCtrl),
                customTextField('AG Number', agNumCtrl),
                customTextField('Age', ageCtrl),
                customTextField('Email', emailCtrl),
                customTextField('Department', departmentCtrl),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: submitForm,
                  child: Text(
                    widget.student == null ? 'Submit' : 'Update',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'package:asdasda/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asdasda/services/database.dart';
import 'package:asdasda/pages/employee.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Stream? EmployeeStream;
  getontheload() async {
    EmployeeStream = await DatabaseMethod().getData();
    setState(() {});
  }

  void initState() {
    getontheload();
    super.initState();
  }

  Widget getUsers() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Material(
                  elevation: 5.0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: " + ds["Name"],
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                nameController.text = ds["Name"];
                                ageController.text = ds["Age"];
                                editUsers(ds["Id"]);
                              },
                              child: Icon(Icons.edit, color: Colors.amber),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await DatabaseMethod().deleteUser(ds["Id"]);
                              },
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Age: " + ds["Age"],
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Employee()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Flutter ",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "App",
              style: TextStyle(
                color: Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
        child: Column(children: [Expanded(child: getUsers())]),
      ),
    );
  }

  Future editUsers(String id) => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    Text(
                      "Edit ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "User",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Age",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {
                        "Name": nameController.text,
                        "Age": ageController.text,
                      };
                      await DatabaseMethod().updateUser(id, updateInfo).then((
                        value,
                      ) {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

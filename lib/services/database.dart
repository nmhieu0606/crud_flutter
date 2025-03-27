import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addEmployee(Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getData() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future updateUser(String id, Map<String, dynamic> employeeInfo) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update(employeeInfo);
  }

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }
}

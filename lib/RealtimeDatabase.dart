
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabase {
  static void write({
    required Map<String, dynamic> data,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref("users/$userId");

      await databaseReference.set(data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> read(String path) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref("users/$userId");
      final snapshot = await _databaseReference.get();

      if (snapshot.exists) {
        return snapshot.child(path).value ?? 0;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}

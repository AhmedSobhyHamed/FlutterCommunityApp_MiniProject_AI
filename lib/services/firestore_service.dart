import 'package:cloud_firestore/cloud_firestore.dart';

/// Singleton — one Firestore entry point for the whole app lifecycle.
class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  factory FirestoreService() => instance;

  FirebaseFirestore get client => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users =>
      client.collection('users');

  CollectionReference<Map<String, dynamic>> get posts =>
      client.collection('posts');

  CollectionReference<Map<String, dynamic>> get donations =>
      client.collection('donations');
}

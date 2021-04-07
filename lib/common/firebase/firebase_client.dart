import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseFirestore _firestoreClient;

  FirebaseClient._() {
    _firestoreClient = FirebaseFirestore.instance;
  }

  static CollectionReference getUsersCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("users");
  }

  static CollectionReference getPaymentsCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("payments");
  }

  static CollectionReference getMenuCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("menu");
  }

  static CollectionReference getComplaintsCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("complaints");
  }

  static CollectionReference getAbsenteesCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("absentees");
  }

  static CollectionReference getNoticesCollectionReference() {
    return FirebaseClient._()._firestoreClient.collection("notices");
  }
}

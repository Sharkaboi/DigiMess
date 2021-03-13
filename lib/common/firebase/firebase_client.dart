import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseFirestore _firestoreClient;

  FirebaseClient() {
    _firestoreClient = FirebaseFirestore.instance;
  }

  static CollectionReference getUsersCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("users");
  }

  static CollectionReference getPaymentsCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("payments");
  }

  static CollectionReference getMenuCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("menu");
  }

  static CollectionReference getComplaintsCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("complaints");
  }

  static CollectionReference getAbsenteesCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("absentees");
  }

  static CollectionReference getNoticesCollectionReference() {
    return FirebaseClient()._firestoreClient.collection("notices");
  }
}

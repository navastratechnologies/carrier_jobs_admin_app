import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

CollectionReference jobsCollection = firestoreInstance.collection('jobs');
CollectionReference favoriteCollection =
    firestoreInstance.collection('favorite');
CollectionReference categoriesCollection =
    firestoreInstance.collection('categories');
CollectionReference usersCollection = firestoreInstance.collection('users');
CollectionReference liveUserCollection =
    firestoreInstance.collection('liveUsers');
CollectionReference countriesCollection =
    firestoreInstance.collection('countries');
CollectionReference feedbacksCollection =
    firestoreInstance.collection('feedbacks');

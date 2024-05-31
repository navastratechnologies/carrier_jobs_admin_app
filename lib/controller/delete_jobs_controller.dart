import 'package:carrier_jobs_app/controller/instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void deleteOldDocuments() async {
  DateTime currentDate = DateTime.now();
  DateTime thirtyDaysAgo = currentDate.subtract(const Duration(days: 30));
  QuerySnapshot snapshot = await jobsCollection.get();

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  for (var i = 0; i < snapshot.docs.length; i++) {
    DateTime docDate = dateFormat.parse(snapshot.docs[i]['date'].toString());
    if (docDate.isBefore(thirtyDaysAgo)) {
      jobsCollection.doc(snapshot.docs[i].id).delete();
    }
  }
}

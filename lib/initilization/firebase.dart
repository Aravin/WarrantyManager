import 'package:firebase_core/firebase_core.dart';

class FirebaseInit {
  FirebaseInit._privateConstructor();

  static final Future<FirebaseApp> instance = Firebase.initializeApp();
}

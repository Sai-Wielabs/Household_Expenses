import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:provider/provider.dart';

import 'package:household_expences/services/database.dart';
import 'package:household_expences/services/greetingService.dart';
import 'package:household_expences/views/Wrapper.dart';
import 'package:household_expences/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(HouseholdExpences());
}

class HouseholdExpences extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final GreetingService _greetingService = GreetingService();

  build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseHelper>(
          create: (_) => DatabaseHelper(),
        ),
        ChangeNotifierProvider<FireApi>(
          create: (_) => FireApi(),
        ),
      ],
      child: GetMaterialApp(
        onInit: () {
          if (_auth.currentUser != null) {
            _greetingService.greeting();
          }
        },
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User>(
            stream: _auth.userChanges(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == null) {
                  return Wrapper();
                } else {
                  return Home();
                }
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                ),
              );
            }),
      ),
    );
  }
}
